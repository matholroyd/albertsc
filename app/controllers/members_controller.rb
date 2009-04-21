class MembersController < ApplicationController
  make_resourceful do
    build :all
  end
  
  def test_worker
    Job.enqueue!(ExampleWorker, :add, 1, 2)
    redirect_to members_path
  end
end
