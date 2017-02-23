instructions to run script

from the terminal open the interactive ruby shell in the same folder as the google_maps_api_scripts.rb file

load the file by running the following command:
`load 'google_maps_api_scripts.rb'`

create a search class using the test lattitude and longitude by running the following command
`banks = PlaceSearch.new(lat: 30.4284750, long: -97.7550500, type: "bank")`

the response can be retrieved after the class is created by running the command:
`banks.response_hash`

the script will accept any valid longitude and lattitude and will accept a type of "bank", "atm" or "all" for both banks and ATMs
and return errors for invalid lat, long or type
