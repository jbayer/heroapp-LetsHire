class Api::V1::MiscController < Api::V1::ApiController

  def test_connection
    render :json => {:ret => 'OK'}
  end

end