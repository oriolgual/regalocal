defmodule Regalocal.Search do
  import Ecto.Query, warn: false
  import Geo.PostGIS

  alias Regalocal.Repo
  alias Regalocal.Admin.Business
  alias Regalocal.Admin.Coupon

  def find_businesses_near!(%Geo.Point{} = geom, limit) do
    bids = business_ids_with_coupons()

    Business
    |> select([b], %{b | distance_meters: st_distance_in_meters(b.coordinates, ^geom)})
    |> where([b], b.id in ^bids)
    |> order_by([b], st_distance_in_meters(b.coordinates, ^geom))
    |> limit(^limit)
    |> Repo.all()
  end

  defp business_ids_with_coupons() do
    Coupon
    |> select([:business_id])
    |> where([c], c.status == "published" and not is_nil(c.business_id))
    |> Repo.all()
    |> Enum.map(fn c -> c.business_id end)
    |> Enum.uniq()
  end

  def get_business!(id), do: Repo.get!(Business, id)

  def active_coupons_for(%Business{id: business_id}) do
    Coupon
    |> where(business_id: ^business_id)
    |> where(status: "published")
    |> Repo.all()
  end
end
