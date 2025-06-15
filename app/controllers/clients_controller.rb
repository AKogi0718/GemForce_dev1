class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = Client.all

    respond_to do |format|
      format.html
      format.csv { send_data Client.to_csv, filename: "clients-#{Date.today}.csv" }
    end
  end

  def show
  end

  def new
    @client = Client.new
  end

  def edit
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: '取引先が正常に登録されました。' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: '取引先が正常に更新されました。' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: '取引先が正常に削除されました。' }
      format.json { head :no_content }
    end
  end

  private
    def set_client
      @client = Client.includes(:products).find(params[:id])
    end

    def client_params
      params.require(:client).permit(
        :code, :name, :name_kana, :alternate_name, :postal_code, :address,
        :billing_cutoff_day, :tel, :fax, :unpaid_balance, :current_balance,
        :contact_person, :email, :payment_terms, :credit_limit, :client_type, :status
      )
    end
end
