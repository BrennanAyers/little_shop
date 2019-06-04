class Address < ApplicationRecord
  belongs_to :user

  validates_presence_of :address, :city, :state, :zip

  before_save :set_nickname

  private

  def set_nickname
    write_attribute(:nickname, 'Home') if self.nickname.nil?
  end
end
