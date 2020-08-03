use_frameworks!
inhibit_all_warnings!

workspace 'AbemaTutorial'

def app_proj
    project './AbemaTutorial.xcodeproj'
end

def ios_platform
    platform :ios, '11.0'
end

target 'AbemaTutorial' do
    app_proj
    ios_platform

    ## Tool
    pod 'SwiftGen', '6.0.0'
    pod 'GRDB.swift', '4.14.0'
end