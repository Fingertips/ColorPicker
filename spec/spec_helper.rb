require "rubygems"
require "bacon"

ROOT = File.expand_path('../../', __FILE__)
ENV['DYLD_FRAMEWORK_PATH'] = File.join(ROOT, 'build', 'Debug')

system "/usr/bin/xcodebuild -project ColorPicker.xcodeproj -target ColorPickerClasses -configuration Debug"
framework 'ColorPickerClasses'

Bacon.summary_at_exit
