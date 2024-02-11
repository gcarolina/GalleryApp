# GalleryApp

Welcome everyone! I'm Karolina, a perspective beginner in iOS-development. 
This iOS application is an image gallery app showcasing proficiency in iOS development. It leverages the Unsplash API to fetch curated photos, allowing users to browse, mark favorites, and view image details. It demonstrates my skills in user interface design, data retrieval, and basic data persistence using Swift as the programming language.

## Frameworks and Pods:
- Utilizes the Unsplash API for fetching images.
- Utilizes URLSession for network requests.
- Integrates AlamofireImage and Kingfisher for efficient response and image caching.
- Uses native CoreData for local database management, ensuring seamless data persistence.
- Implements SwiftLint for code style enforcement.
- Integrates Skeleton View for smooth loading animations, enhancing user experience.

## Patterns
Dependency Injection is employed to manage dependencies, making the codebase modular and easy to test.

## Architecture
The app follows the MVVM (Model-View-ViewModel) architecture for a clear separation of concerns, ensuring maintainability and testability.

## Key Functionalities:
 **Image Gallery Screen:**
*  Displays a grid of thumbnail images fetched from the Unsplash API.
*  Implements pagination to load more images as the user scrolls.
*  Tappable thumbnails lead to the Image Detail Screen.
   
 **Image Detail Screen:**
- Shows the selected image in a larger view with additional details.
- Allows users to mark images as favorites with a heart-shaped button.
- Basic swipe gestures for easy navigation between images in the detail view.

<img src="https://github.com/gcarolina/GalleryApp/assets/70655454/e77df9b3-c16a-4d27-96b3-4dc9b422b656" width="220" height="445">

<img src="https://github.com/gcarolina/GalleryApp/assets/70655454/16ff955b-68a1-4107-9409-9aedde4ff75b" width="220" height="445">

<img src="https://github.com/gcarolina/GalleryApp/assets/70655454/0dd16800-1b75-4be0-bce9-26c42b8677b7" width="220" height="445">

## How to Run the App
1) Clone the repository from https://github.com/gcarolina/GalleryApp.

2) Install the application dependencies:
   
   $ cd /GalleryApp
   
   $ pod install

4) Open the file GalleryApp.xcworkspace in XCode.
5) Build and run the project on an iOS 13 or above device or simulator.

## Contact Information
For any inquiries or feedback, feel free to contact me through my LinkedIn profile https://www.linkedin.com/in/karolinaganizoda/. Thank you for exploring the Gallery App!
