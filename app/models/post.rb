class Post < ActiveRecord::Base
  validates_uniqueness_of :jobtitle, :company, conditions: -> { where(remote: IS_REMOTE) }

  IS_REMOTE='y'

  def flagremote
    self.remote=IS_REMOTE
  end

end
