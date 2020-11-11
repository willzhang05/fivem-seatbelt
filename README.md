# fivem-seatbelt
Launches player through the windshield if a huge change in velocity happens (eg. crash).  

Press K to enable / disable seatbelts.

## Configuration
* `Cfg.Strings` changes in-game seatbelt messages
* `Cfg.DiffTrigger` scales the difference in velocity needed to trigger an ejection
* `Cfg.MinSpeed` changes the minimum speed at which `Cfg.BaseEjectRate` applies
* Random ejection rate can be adjusted based on the equation `ejectRate = Cfg.EjectRateScale * speed difference + Cfg.BaseEjectRate`

Note: You have to open your seatbelt to leave the vehicle.


FiveM API docs for development: https://runtime.fivem.net/doc/natives/

Statistics for random ejection thresholds: https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/809199
