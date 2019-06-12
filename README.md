# JSPhotoGallery
A library used to display images in a gallery view as well as in a thumbnail summary grid



## Usage

Instantiating the gallery

            let navController = JSPhotoGallery.create(imageURLs: urls)  //Instantiate with Image URLs
            
            let navController = JSPhotoGallery.create(images: images)   //Instantiate with Images
            
            let navController = JSPhotoGallery.create(images: images,
                                     shouldStartInFullScreen: true)   //Launch in full screen mode
                                     
            let navController = JSPhotoGallery.create(images: images,
                                     shouldStartInFullScreen: true,
                                                 intialIndex: 2)   //Launch in full screen mode on 2nd image


Presenting the gallery

            present(navController, animated: true)
            
Appearance Settings

            JSPhotoGallery.settings.backgroundColor = .black
            JSPhotoGallery.settings.navBackgroundColor = .black
            JSPhotoGallery.settings.navTitleColor = .white
            JSPhotoGallery.settings.navTitle = "Images"
            
Customizing buttons - *Coming soon*


