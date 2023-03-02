# constants-resolver
A tool for tracking down not resolving constants in Ruby projects.
See the context: https://blog.arkency.com/tracking-down-not-resolving-constants-with-parser/

Usage:
```bash
bundle exec ruby collector.rb app/
```

Expected output:
```
[PROJECT_ROOT]/app/controllers/vehicles/cars_controller.rb:3:15   ::Car

[PROJECT_ROOT]/app/controllers/vehicles/plains_controller.rb:3:30 ::Paginatiors::SimplePaginator
[PROJECT_ROOT]/app/controllers/vehicles/plains_controller.rb:3:60 Vehicles::Plain

[PROJECT_ROOT]/app/models/vehicles/car.rb:5:19    Presenters::CarPresenter
```