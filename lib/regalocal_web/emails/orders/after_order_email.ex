defmodule RegalocalWeb.Orders.AfterOrderEmail do
  use Phoenix.Swoosh, view: RegalocalWeb.Orders.EmailView

  def generate(conn, gift, business, token) do
    new()
    |> to({gift.buyer_name, gift.buyer_email})
    |> cc({business.owner_name, business.email})
    |> reply_to({business.owner_name, business.email})
    |> from(from_email())
    |> subject("Instruccions de pagament compra - #{gift.reference}")
    |> render_body("after_order.html", %{conn: conn, gift: gift, business: business, token: token})
  end

  defp from_email do
    {Application.get_env(:veil, :email_from_name),
     Application.get_env(:veil, :email_from_address)}
  end
end