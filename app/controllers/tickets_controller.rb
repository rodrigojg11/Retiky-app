class TicketsController < ApplicationController
  def index
    @tickets = Ticket.all
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
def start_lightning_offer
  @ticket = Ticket.find(params[:id])

  horas = params[:horas].to_f
  descuento = params[:descuento].to_i

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
    params.require(:ticket).permit(:from, :to, :price, :date)
  end

end
