class MembersController < ApplicationController
  make_resourceful do
    build :all
  end
  
  def import
  end
  
  def import_file
    file = params[:file]
    Importing.import_from_file(file.read)

    redirect_to members_path
  end
  
end
