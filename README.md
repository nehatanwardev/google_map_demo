# Flutter Map App

This Flutter app allows users to interact with a Google Map, add markers with labels, and save or remove them. The app utilizes the Provider package for state management.

## Instructions to Run the App

1. Make sure you have Flutter installed. If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).


2. Clone the repository to your local machine.
   
   git clone  https://github.com/nehatanwardev/google_map_demo.git
   
3. Navigate to the project directory.
  
   cd google_map
   
4. Install dependencies.
   
   flutter pub get
  
5. Run the app.
   
   flutter run
  

## App Functionality

The app provides the following features:

- **Interactive Map**: Display a Google Map with the ability to add markers on tap.

- **Marker Information**: Tap on a marker to view information in a popup dialog.

- **Add Markers**: Tap on Map  to add a marker with a customizable label. A dialog will prompt you to enter the label.

- **Remove Markers**: Press the "Remove Markers" button to clear all markers from the map. This action is irreversible.

- **Save Markers**: Press the "Save Markers" button to persistently save added markers. The markers will be loaded on app restart.

## Additional Notes

- The app uses the Provider package for state management, separating the UI from the data and logic.

- Markers are saved using `SharedPreferences` for persistence, allowing the app to remember markers between sessions.

- The code is organized into multiple files for better readability and maintainability.

- The default location on the map is set to coordinates (28.4595, 77.0266).

- Ensure that you have an internet connection to load the Google Map.

