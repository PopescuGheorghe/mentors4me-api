module Api
  module V1
    class ContextsController < Api::BaseController
      before_action :set_context, only: [:show, :update, :destroy, :accept]
      respond_to :json

      def show
        respond_with build_data_object(@context)
      end

      def index
        respond_with build_data_object(Context.all)
      end

      def accept
        @context.update(accepted: true)
        if @context.save!
          render json: build_data_object(@context), status: 200
        else
          render json: build_error_object(@context), status: 422
        end
      end

      def create
        Profile.find_by!(id: params[:profile_id])
        Organization.find_by!(id: params[:organization_id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('profile or organization is invalid', 422)
      else
        context = Context.new(context_params)
        if context.save
          render json: build_data_object(context), status: 200
        else
          render json: build_error_object(context), status: 422
        end
      end

      private

      def set_context
        @context = Context.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('context not found', 404)
      end

      def context_params
        params.permit(:profile_id, :organization_id, :description)
      end
    end
  end
end
