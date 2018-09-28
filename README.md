# OS Activity Generator

### Setup
1. clone the repo: `git clone git@github.com:btbam/activity_generator.git`
2. `cd activity_generator`
3. `bundle`
3. `ruby ./scripts/generate_activity.rb ./data/set1.json ./event_results1.json`
4. `ruby ./scripts/generate_activity.rb ./data/set2.json ./event_results2.json`
5. There will now be 2 output files named event_results1.json and event_results2.json in the root of this repo
6. To run tests: `rake spec`


### TODO
1. I used the most basic cases for development and testing.  More complicated scenarios are sure to exist that this codebase will not cover right now.
2. Gemfile may not contain all of the needed gems. I use rbenv locally which doesn't support gemsets out of the box.  I didn't have time to get a proper vbox/docker going.
3. The tests only check on the 'mac' OS scenario.  More scenario are needed for each OS.
4. The windows commands are a best guess.  Actual testing on a windows machine is needed.
5. Tests can be refactored using shared examples and contexts.
6. Dependency inject the 'process strategies' through the StartActivity class instead of having them hard coded into the switch.