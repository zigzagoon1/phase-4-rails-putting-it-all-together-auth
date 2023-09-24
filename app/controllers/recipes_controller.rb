class RecipesController < ApplicationController
    before_action :authorize
    def index
        recipes = Recipe.all
        render json: recipes, include: :user
    end


    def create
        recipe = Recipe.create(recipe_params)
        recipe.user_id = session[:user_id]
        recipe.save
        if recipe.valid?
            render json: recipe, include: :user, status: :created
        else
            render json: {errors: recipe.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private
    
    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

    def authorize
        render json: {errors: ["Unauthorized"]}, status: :unauthorized unless session.include? :user_id
    end
end
