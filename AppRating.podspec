Pod::Spec.new do |spec|
  spec.name = "AppRating"
  spec.version = "0.0.1"
  spec.summary = "AppRating"
  spec.homepage = "https://github.com/grizzly/AppRating"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Grizzly" => 'st.mayr@grizzlynt.com' }

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/grizzly/AppRating.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "AppRating/**/*.{h,swift}"

end
