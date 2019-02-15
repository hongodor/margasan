module FileCheckService
  class << self
    def create(filename)
      if filename =~ /Map\d*.json/
        return true
      else
        return false
      end
    end
  end
end