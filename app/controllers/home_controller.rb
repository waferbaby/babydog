class HomeController < ApplicationController
  def index
    render plain: "hey, this is the main page."
  end
end
