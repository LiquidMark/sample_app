# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, :all_after_pass => false do

  # Added per tutorial section 3.33 of 
  #    http://ruby.railstutorial.org/chapters/static-pages?version=3.2#top
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
    ["spec/routing/#{m[1]}_routing_spec.rb",
     "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
     "spec/acceptance/#{m[1]}_spec.rb",
     "spec/requests/#{m[1]}_spec.rb"]
  end
  watch(%r{^app/views/(.+)/}) { |m| "spec/requests/#{m[1]}_spec.rb" }
    
end
