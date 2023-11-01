require "parser/runner"
require "unparser"
require "set"
require "rubocop"

require_relative "config/environment"

class Collector < Parser::AST::Processor
  include AST::Sexp

  def initialize
    @store = Set.new
    @root_path = File.expand_path(__dir__)
  end

  def suspicious_consts
    @store.to_a
  end

  def on_const(node)
    return if node.parent.module_definition?
    return if node.parent.class_definition?

    namespace = node.namespace
    while namespace
      return if namespace.lvar_type?
      return if namespace.send_type?
      return if namespace.self_type?
      break if namespace.cbase_type?
      namespace = namespace.namespace
    end
    const_string = Unparser.unparse(node)

    if node.namespace&.cbase_type?
      store(const_string, node.location) unless validate_const(const_string)
    else
      namespace_const_names =
        node
          .each_ancestor
          .select { |n| n.class_type? || n.module_type? }
          .reverse
          .map { |mod| mod.children.first.const_name }

      (namespace_const_names.size + 1).times do |i|
        concated = (namespace_const_names[0...namespace_const_names.size - i] + [node.const_name]).join("::")
        return if validate_const(concated)
      end
      store(const_string, node.location)
    end
  end

  def store(const_string, location)
    @store << [
      File.join(@root_path, location.name.to_s),
      const_string
    ]
  end
end

def validate_const(namespaced_const_string)
  eval(namespaced_const_string)
  true
rescue NameError, LoadError
  false
end

runner =
  Class.new(Parser::Runner) do
    class << self
      attr_accessor :_has_errors
    end

    def runner_name
      "dudu"
    end

    def process(buffer)
      parser = @parser_class.new(RuboCop::AST::Builder.new)
      collector = Collector.new
      collector.process(parser.parse(buffer))
      show(collector.suspicious_consts)
    end

    def show(collection)
      return if collection.empty?
      puts
      collection.each { |pair| puts pair.join("\t") }
      self.class._has_errors = true
    end
  end

runner.go(ARGV)
exit 1 if runner._has_errors
