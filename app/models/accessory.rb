class Accessory < ApplicationRecord
  belongs_to :bicycle
  enum accessory_type: { sonnette: 0, antivol: 1, garde_boue: 2, support_telephone: 3, sac_a_dos: 4, pompe: 5, casque: 6, sacoche_selle: 7, antivol_roue: 8, gants: 9, compteur_vitesse: 10, sac_guidon: 11, reflecteurs: 12, kit_reparation: 13, gilet_reflechissant: 14 }
end
