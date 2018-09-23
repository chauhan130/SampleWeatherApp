
# SampleWeatherApp
A sample weather app that shows user location on interactive map with current weather.
The user's location is displayed on the map. You can go to any location by tracking the map view. You can zoom in/out with pinch gesture. Long pressing anywhere on the map will get you to the next screen where you will get the weather information of that location.

Tapping on the user's current location will get weather information of the current location.


The *WeatherAPI* framework gets the weather information from [OpenWeatherMap](https://openweathermap.org). You pass the CLLocation instance and it will get the weather information in `LocationWeatherInfo` instance. The `LocationWeatherInfo` makes sure the units are preserved appropriately according to the server. iOS shows localized units automatically.

Todo:
- [ ] Implement MVP/MVVM pattern.
- [ ] Render weather information more beautifully.
- [ ] Use FlowController to navigate through screens.
- [ ] Cache location that was fetched previously.
- [ ] Add settings screen to allow user to opt not to get city name and fetch the weather information from coordinates.
- [ ] Add test cases for *WeatherAPI* framework.

