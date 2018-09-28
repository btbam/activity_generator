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
1. I used the most basic cases for development and testing.  More complicated scenarios are sure to exist that this codebase will not cover right now. I focused more on the 80% than the 20% of the 80/20 rule and avoided getting too far into the weeds with details.  There are probably a lot of edge cases missing.
2. The tests only check on the 'mac' OS scenario.  More scenario are needed for each OS.
3. The windows commands are a best guess.  Actual testing on a windows machine is needed.
4. Tests can be refactored using shared examples and contexts.
5. Dependency inject the 'process strategies' through the StartActivity class instead of having them hard coded into the switch.