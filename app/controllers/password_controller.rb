class PasswordController < ApplicationController
  def index
  end

  def create
    #rate limit
    if response.status == 429
      flash[:alert] = "You have reached the rate limit. Please try again later."
      return render :index
    end

    session[:password_length] = params[:passwordLength]
    session[:with_numbers] = params[:withNumbers] == 'on'
    session[:with_special_signs] = params[:withSpecialSigns] == 'on'

    # session variables
    password_length = session[:password_length]
    with_numbers = session[:with_numbers]
    with_special_signs = session[:with_special_signs]

    puts with_numbers, with_special_signs

    @password = generate_password(password_length, with_numbers, with_special_signs)
    puts @password

    render :index
  end

  private

  def generate_password(password_length, with_numbers, with_special_signs)
    password_length = password_length.to_i
    chars = ('a'..'z').to_a + ('A'..'Z').to_a
    number_chars = ('0'..'9').to_a
    special_chars = %w[! @ # $ % ^ & *]

    password = []
    password << number_chars.sample if with_numbers
    password << special_chars.sample if with_special_signs

    remaining_length = password_length - password.length
    remaining_chars = chars.dup # Create a duplicate of chars array to avoid modifying the original
    remaining_chars += number_chars if with_numbers
    remaining_chars += special_chars if with_special_signs

    password += Array.new(remaining_length) { remaining_chars.sample }
    password.shuffle.join
  end


end
