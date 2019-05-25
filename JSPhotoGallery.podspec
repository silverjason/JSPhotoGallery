

Pod::Spec.new do |s|


  s.name         = "JSPhotoGallery"
  s.version      = "1.0"
  s.summary      = "A library used to display images in a gallery view as well as in a thumbnail summary grid."

  s.description  = "I could not find another image viewer library that met all my needs. I decided to 
  create a basic image viewer that was customizable, easy to use, and had a full view as well
  as a grid summary view of all the images as thumbnails"

  s.homepage     = "http://raywenderlich.com"

  s.license = "MIT"

  s.author             = { "Jason" => "silver.jase@gmail.com" }

  s.platform     = :ios, "12.0"

  s.source       = { :git => "https://github.com/silverjason/JSPhotoGallery.git", :tag => "1.0", :branch => "1.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.

  s.source_files  = ["JSPhotoGallery/JSPhotoGallery.h",
    "JSPhotoGallery/**/*.swift"]

  s.resources = ["JSPhotoGallery/**/*.{storyboard,xib}"]

  s.public_header_files = ["JSPhotoGallery/JSPhotoGallery.h"]

  s.dependency "Kingfisher", "~> 5.5.0"

  s.swift_version = "5" 


end

  # ――― **REMINDERS** ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  #'pod cache clean --all' IS YOUR FRIEND
  # Make sure to push your pod and point to correct branch in s.source