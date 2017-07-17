class TopController < ApplicationController
  def index
    dummy_users = {
      "users": [
        {"id": 1, "name": "Tanaka",     "friends": [2,3]},
        {"id": 2 ,"name": "Yamada",    "friends": [1,5]},
        {"id": 3 ,"name": "Sato",      "friends": [1]},
        {"id": 4 ,"name": "Suzuki",    "friends": []},
        {"id": 5 ,"name": "Takahashi", "friends": [2]}
      ]
    }

    render json: dummy_users
  end
end
