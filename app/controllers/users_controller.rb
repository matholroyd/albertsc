class UsersController < ApplicationController
  make_resourceful do
    build :all
  end
end
