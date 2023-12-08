class BicyclesController < ApplicationController
  before_action :set_bicycle, only: %i[ edit update destroy ]

  # GET /bicycles or /bicycles.json
  def index
    @bicycles = Bicycle.all
  end

  # GET /bicycles/1 or /bicycles/1.json
  def show
    @bicycle = Bicycle.find(params[:id])
  end

  # POURQOI CETTE METHODE EST-ELLE ICI SYLVAIN?
  #SI ELLE EST DANS LE PRIVATE, ELLE NE DEVRAIT PAS ETRE ACCESSIBLE DE L'EXTERIEUR ET DONC NE PAS POUVOIR ETRE APPELEE PAR LE ROUTER
  #EN PLUS, ELLE EST DEJA DEFINIE DANS LE PRIVATE DE CE CONTROLLER (en majuscule car jai oublie de desactiver le caps lock et jai la flemme de tout reecrire)
  #si tu as besoin de cette methode dans un autre controller, tu peux la mettre dans le application_controller
  #ou la mettre dans un module et l'inclure dans les controllers qui en ont besoin
  #ou la mettre dans un concern et l'inclure dans les controllers qui en ont besoin
  #ou la mettre dans un helper et l'inclure dans les controllers qui en ont besoin
  #ou la mettre dans un service et l'appeler dans les controllers qui en ont besoin
  
#           .s$P*.s$$$s.`*T$$b T TP$P.d$P .sd$s.                
#         .s$P .s$$$$$$$b. T$$b T:P d$$P.d$$$$$$bs.             
#        d$$P d$$$$P'`T$$$b $$$;:$bd$$$$$$b`T$$*$$$b.           
#       d$$P d$$$P' .+. *$$:$$$;.$$$P^*""*^b.$$b T$$$b          
#      d$P .d$$$b.s$$$$$b TP^TP dP',d$$$$$s.`T$$b T$$$b         
#     d$P d$$P T$$$P*""*^b.b d,P^*"*^T$$$$$$$b`T$b$$$$$.        
#    ,$P d$P .$$$P'       `'*`        `T$$$$$$$b`T$$$$$$         
#    :$ d$P d$$$P                       `T$$$$$$b TPT$$$b        
#   :$$d$$ d$$$P                          T$$$$$$b T.`T$$;       
#   :$$$$$d$$$P                            T$$$$ $b T.T$$:       
#   $$$$$P$$$$                              T$$$$T$b T `T$       
#   $P$$$;$$$;                               T$^$b Tb b :$       
#   $`$$$ $$$;                                T.T$b TY$,:$       
#   $:$$$ $$$'                                `$ T$; $$;'$       
#   $;$$$;$$$                                  `b T; $$$ $       
#   $:T$$;$$$  .d$$s.                    .s$$b..$;:$;$$$.T       
#  / __`*:$$$ *'   `*Tb._            _.dP*'   `*$;:$:$P__ \      
# ..' .`.:$$$         `*Ts'        `sP*'        $$:$$P'. `,,     
# ;  /   ,$$;   .+s**s.   `.           .s**s+.  T$:PP'  \  :     
# : ,   /:$$;   \ *ss* \    ;         / *ss* /    +: \   . ;     
#  .`  :  $$;,  .+s$$$s+.            .+s$$$s+.  .* ;  ;  ',      
#   \   *.:$$,*d$P*"$$$T$b  ,+**+,  d$P*"$$$T$b*   .*    /       
#    \    `$$;:$; +:$$$:$$;*      *:$; +:$$$:$$;  :     /        
#          $$; T$b._$$$d$P          T$b._$$$d$P   ;              
#      `._.:$$, `*T$$$P*'            `*T$$$P*'    :._.'          
#          |$$;             '                     |P$$b.         
#          ;`$$,           :.     ,               :b.`T$b        
#          ` T$$b._        `*.__.*'               d$$b T$b       
#           . *TP*'           ""                 d$$$$b.:$;      
#            \                                  dP T$$$$$$$      
#             \          .+*"*--*"*+.          d$b. T$$^$$$      
#              `.       :._.--..--._.;       .'$$$$; $$ $$$      
#                ;.      `.        .'      .'  $$$$$ $P $$;      
#                : `.      `*----*'      .'    $$$$$ $b $P       
#                |   `.                .'      $$$$$Y$$dP        
#         [bug]  :     `.            .'        :T$$P$$P,db.      
#               /        `-.      .-'          dbT d$Pd$$$$b.    
#              /            `****'            d$$$PT$$$b T$$$b   
#            .'                              d$$$P db`T$b T$$$b  
#         _.'                               :$$$P.d$$b:$$$`$$$$; 
#    _.-*' `.                               $$$$:$$$$$;$$$:$$$$$ 
#            `-.                            :$$$;$$$$$$$$$;$$$$$ 
#               `-.                        .-T$$$$P$$$$$P d$$$$; 
#                  `.     `.     .*      .'   T$$$b`T$P.sd$$$$P  
#                    `.     `-  '      .'      `T$$b$$$$$$$$P'   
#                      `.            .'          `T.T$$$$P$$$b.  
#                        `.        .'             :$$$$P'd$$$$$;  
#                          `.    .'               $$$$$:d$;$$$$$.
#                            `..'                 :$$$$;$$$b`T$$;
#                                                  T$$$:$$$$; $$$
#                                                   T$$$T$$$;d$$;
#                                                    `T$b`T$$$$P 
#                                                      `*b T$P'
 
 
 
  def bicycle_params
    params.require(:bicycle).permit(:model, :bicycle_type, :size, :condition, :price_per_hour, :latitude, :longitude, :address, :description, :image)
  end

  # GET /bicycles/new
  def new
    @bicycle = Bicycle.new
  end

  # GET /bicycles/1/edit
  def edit
  end

  # POST /bicycles or /bicycles.json
  def create
    @bicycle = Bicycle.new(bicycle_params)
    @bicycle.owner = current_user

    respond_to do |format|
      if @bicycle.save
        format.html { redirect_to bicycle_url(@bicycle), notice: "Bicycle was successfully created." }
        format.json { render :show, status: :created, location: @bicycle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bicycle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bicycles/1 or /bicycles/1.json
  def update
    respond_to do |format|
      if @bicycle.update(bicycle_params)
        format.html { redirect_to bicycle_url(@bicycle), notice: "Bicycle was successfully updated." }
        format.json { render :show, status: :ok, location: @bicycle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bicycle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bicycles/1 or /bicycles/1.json
    def destroy
      if @bicycle.destroy
        redirect_to bicycles_path, notice: 'Bicycle was successfully deleted.'
      else
        redirect_to bicycles_path, alert: @bicycle.errors.full_messages.to_sentence
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bicycle
      @bicycle = Bicycle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bicycle_params
      params.require(:bicycle).permit(:owner_id, :model, :bicycle_type, :size, :condition, :price_per_hour, :latitude, :longitude,
        :address, :city, :country, :postal_code, :state)
    end
   
end
