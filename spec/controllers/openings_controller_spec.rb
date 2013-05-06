require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe OpeningsController do

  # This should return the minimal set of attributes required to create a valid
  # Opening. As you add validations to Opening, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for(:opening).merge({:hiring_manager_id => @hiring_manager1.id,
      :recruiter_id => @recruiter1.id,
      :department_id => @hiring_manager1.department_id,
      :status => 1})
  end


  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OpeningsController. Be sure to keep this updated too.
  def valid_session
  end

  before :each  do
    @hiring_manager1 = create_user(:hiring_manager)
    @recruiter1 = create_user(:recruiter)
    @user1 = create_user(:user)

    request.env["devise.mapping"] = Devise.mappings[:user]
    Opening.any_instance.stub(:select_valid_owners_if_active).and_return(true)
  end

  describe 'Anonymous User' do
    describe "GET index" do
      it "only returns published openings for anonymous user" do
        Opening.create! valid_attributes
        opening2 = Opening.create! valid_attributes.merge(:status => 0)
        get :index, {}
        assigns(:openings).index(opening2).should be_nil
      end

    end

    describe "GET show" do
      it "assigns the requested opening as @opening" do
        opening = Opening.create! valid_attributes
        get :show, {:id => opening.to_param}
        assigns(:opening).should eq(opening)
      end
    end

  end

  describe 'Registered User' do
    before :each  do
      sign_in_as_admin
    end


    describe "GET index" do
      it "return opening list correctly based on ownership" do
        Opening.create! valid_attributes
        opening1 = Opening.create! valid_attributes, :status => 0
        get :index, {}
        assigns(:openings).index(opening1).should nil
        get :index, { :all => true}
        assigns(:openings).index(opening1).should be_true

        sign_in @user1
        get :index, { :all => true}
        assigns(:openings).index(opening1).should be_true

        Opening.stub(:owned_by).and_return(Opening)
        sign_in @hiring_manager1
        get :index, {}
        assigns(:openings).index(opening1).should be_true
        get :index, { :all => true}
        assigns(:openings).index(opening1).should be_true
      end
    end


    describe "GET new" do
      it "assigns a new opening as @opening" do
        get :new, {}
        assigns(:opening).should be_a_new(Opening)
      end
    end

    describe "GET edit" do
      it "assigns the requested opening as @opening" do
        opening = Opening.create! valid_attributes
        get :edit, {:id => opening.to_param}
        assigns(:opening).should eq(opening)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Opening" do
          expect {
            post :create, {:opening => valid_attributes}
          }.to change(Opening, :count).by(1)
        end

        it "assigns a newly created opening as @opening" do
          post :create, {:opening => valid_attributes}
          assigns(:opening).should be_a(Opening)
          assigns(:opening).should be_persisted
        end

        it "redirects to the created opening" do
          post :create, {:opening => valid_attributes}
          response.should redirect_to(Opening.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved opening as @opening" do
          # Trigger the behavior that occurs when invalid params are submitted
          Opening.any_instance.stub(:save).and_return(false)
          post :create, {:opening => {}}
          assigns(:opening).should be_a_new(Opening)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Opening.any_instance.stub(:save).and_return(false)
          post :create, {:opening => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested opening" do
          opening = Opening.create! valid_attributes
          # Assuming there are no other openings in the database, this
          # specifies that the Opening created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Opening.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => opening.to_param, :opening => {'these' => 'params'}}
        end

        it "assigns the requested opening as @opening" do
          opening = Opening.create! valid_attributes
          put :update, {:id => opening.to_param, :opening => valid_attributes}
          assigns(:opening).should eq(opening)
        end

        it "redirects to the opening" do
          opening = Opening.create! valid_attributes
          put :update, {:id => opening.to_param, :opening => valid_attributes}
          response.should redirect_to(opening)
        end
      end

      describe "with invalid params" do
        it "assigns the opening as @opening" do
          opening = Opening.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Opening.any_instance.stub(:save).and_return(false)
          put :update, {:id => opening.to_param, :opening => {}}
          assigns(:opening).should eq(opening)
        end

        it "re-renders the 'edit' template" do
          opening = Opening.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Opening.any_instance.stub(:save).and_return(false)
          put :update, {:id => opening.to_param, :opening => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested opening" do
        opening = Opening.create! valid_attributes
        expect {
          delete :destroy, {:id => opening.to_param}
        }.to change(Opening, :count).by(-1)
      end

      it "redirects to the openings list" do
        opening = Opening.create! valid_attributes
        delete :destroy, {:id => opening.to_param}
        response.should redirect_to(openings_url)
      end
    end
  end

end
