module ActsAsAsync
  class MissingIDError < StandardError
    def initialize
      @message = "Cannot async methods on a record with no ID (i.e. unsaved records)."
    end
  end
end
