class Ticket < ApplicationRecord
  AIRPORTS = [
    ["Ciudad de México (MEX)", "MEX"],
    ["Guadalajara (GDL)", "GDL"],
    ["Cancún (CUN)", "CUN"],
    ["Nueva York - JFK (JFK)", "JFK"],
    ["Los Ángeles (LAX)", "LAX"],
    ["Miami (MIA)", "MIA"],
    ["Toronto (YYZ)", "YYZ"],
    ["Madrid (MAD)", "MAD"],
    ["París - Charles de Gaulle (CDG)", "CDG"],
    ["Londres - Heathrow (LHR)", "LHR"],
    ["Tokio - Narita (NRT)", "NRT"]
  ]
  belongs_to :user
  has_many :orders, dependent: :destroy
  attr_accessor :duracion, :descuento_temporal

  # Validaciones usando los nombres de campos de tu migración
  validates :to, presence: true, length: { maximum: 50}
  validates :from, presence: true, length: { maximum: 50}
  validates :date, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validate :date_not_in_past
  validate :from_different_from_to
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  include PgSearch::Model
  pg_search_scope :search_tickets,
    against: [ :from, :to ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

  def has_active_offer?
    discount.present? && discount > 0 && lightning_offer_active?
  end

  def discount_price
    return price unless has_active_offer?
    price - (price * discount / 100)
  end

  def ruta_completa
    "#{from} → #{to}"
  end

  def discount_percentage
    discount || 0
  end

  def tiempo_restante_oferta
    tiempo_restante = tiempo_restante_horas
    return "Oferta expirada" if tiempo_restante <= 0
    return "Sin oferta relámpago" unless lightning.present? && lightning > 0

    if tiempo_restante >= 1
      horas = tiempo_restante.floor
      "#{horas} hora#{'s' if horas != 1} restante#{'s' if horas != 1}"
    else
      minutos = (tiempo_restante * 60).floor
      "#{minutos} minuto#{'s' if minutos != 1} restante#{'s' if minutos != 1}"
    end
  end

  def iniciar_oferta_relampago!(duracion_horas, descuento_porcentaje)
    update!(
      lightning: duracion_horas,
      lightning_start_time: Time.current,
      discount: descuento_porcentaje
    )
  end

  def detener_oferta_relampago!
    update!(
      lightning: 0,
      lightning_start_time: nil,
      discount: 0
    )
  end

  private

  def date_not_in_past
    return unless date

    # Convertir string a fecha si es necesario
    if date.is_a?(String)
      begin
        parsed_date = Date.parse(date)
      rescue ArgumentError
        return # Si no se puede parsear, skip la validación
      end
    else
      parsed_date = date
    end

    return unless parsed_date

    errors.add(:date, 'no puede ser en el pasado') if parsed_date < Date.current
  end

  def from_different_from_to
    return unless from && to
    errors.add(:to, 'debe ser diferente al origen') if from.downcase == to.downcase
  end


  def lightning_offer_active?
    tiempo_restante_horas > 0
  end

  def tiempo_restante_horas
    return 0 unless lightning.present? && lightning > 0 && lightning_start_time.present?

    tiempo_transcurrido = (Time.current - lightning_start_time) / 1.hour
    tiempo_restante = lightning - tiempo_transcurrido
    [tiempo_restante, 0].max
  end


  def oferta_expirando_pronto?
    tiempo_restante = tiempo_restante_horas
    tiempo_restante > 0 && tiempo_restante <= 0.5 # Menos de 30 minutos
  end

  def porcentaje_urgencia
    tiempo_restante = tiempo_restante_horas
    return 0 if tiempo_restante <= 0

    # Ofertas relámpago cortas (máximo 6 horas)
    return 100 if tiempo_restante <= 0.25  # Crítico
    return 90 if tiempo_restante <= 0.5    # Muy urgente
    return 75 if tiempo_restante <= 1      # Urgente
    return 50 if tiempo_restante <= 2      # Moderado
    return 25 if tiempo_restante <= 4      # Bajo
    10 # Muy bajo: más de 4 horas
  end
end
