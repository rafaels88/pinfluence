def database_clean
  repositories.each(&:clear)
end

def repositories
  return @_repositories if !@_repositories.nil?

  rep_paths = Dir[Hanami.root.join('lib/pinfluence/repositories/*.rb')]
  @_repositories = rep_paths.map do |r|
    filename = File.basename r, '.rb'
    class_name = filename.split("_").collect(&:capitalize).join
    Object.const_get(class_name).new
  end
end
