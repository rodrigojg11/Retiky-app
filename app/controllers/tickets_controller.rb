class TicketsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    if params[:from].present? || params[:to].present?
      query = [
        params[:from],params[:to]
      ].compact.join(' ')
      @tickets = Ticket.search_tickets(query).order(date: :asc)
    else
      @tickets = Ticket.order(date: :asc)
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = current_user.tickets.build(ticket_params)
    if @ticket.save
      redirect_to @ticket, notice: 'Ticket was successfully created.'
    else
      render :new
    end
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    @ticket = Ticket.find(params[:id])

    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: 'Ticket actualizado!'
    else
      render :edit
    end
  end


  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    redirect_to tickets_path, notice: 'Ticket eliminado!'
  end

# esta es la que es rara
  def create_lightning_offer
  @ticket = Ticket.find(params[:id])

  duracion = ticket_params[:duracion].to_f
  descuento = ticket_params[:discount].to_i

  # Validaciones
    if duracion < 0.5 || duracion > 6
      redirect_to @ticket, alert: "La duración debe ser entre 0.5 y 6 horas"
      return
    end

    if descuento < 1 || descuento > 50
      redirect_to @ticket, alert: "El descuento debe ser entre 1% y 50%"
      return
    end

  # Crear la oferta
    @ticket.update!(
      discount: descuento,
      lightning: duracion,
      lightning_start_time: Time.current
    )
    flash[:show_confirm_popup] = true
    redirect_to @ticket, notice: "¡Oferta relámpago creada exitosamente!"

  rescue => e
    redirect_to @ticket, alert: "Error al crear la oferta: #{e.message}"
  end

  def purchase_confirmation
    @ticket = Ticket.find(params[:id])
  end


  def start_lightning_offer
  @ticket = Ticket.find(params[:id])

  horas = params[:horas].to_f
  descuento = params[:discount].to_i

  @ticket.iniciar_oferta_relampago!(horas, descuento)
  redirect_to @ticket, notice: '¡Oferta relámpago iniciada!'
  end

  def stop_lightning_offer
  @ticket = Ticket.find(params[:id])
  @ticket.detener_oferta_relampago!
  redirect_to @ticket, notice: 'Oferta detenida'
  end

  private
  def ticket_params
    params.require(:ticket).permit(:duracion, :discount, :from, :to, :price, :date)
  end

end
