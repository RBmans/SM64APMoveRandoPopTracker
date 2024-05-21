function has(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    amount = tonumber(amount)
    if not amount then
        return count > 0
    else
        return count >= amount
    end
end

function bob_island()
	return has("bob") or (has("cannons") and has("wc") and has("tj")) or (has("caps") and has("cannons") and has("lj"))
end

function jrb_upper()
	return has("tj") or has("bf") or has("sf") or has("wk") or (has("moves") and has("lg"))
end

function ccm_wk()
	return ((has("tj") or has("wk")) and (has("ccm") or has("cannons"))) or (has("moves"))
end

function bbh_upper()
	return (has("wk") and has("lg")) or (has("moves") and has("wk"))
end

function bbh_roof()
	return has("lj") or has("moves")
end

function hmc_reds()
	return (has("cl") and (has("wk") or has("lg") or has("bf") or has("sf") or has("tj"))) or (has("moves") and has("wk"))
end

function hmc_pit()
	return (has("tj") and has("cl")) or (has("moves") and has("wk") and (has("tj") or has("lj"))) or (has("moves") and has("wk") and has("sf") and has("lg"))
end

function hmc_metal()
	return (has("lj") and has("mc")) or (has("caps") and has("lj") and has("tj")) or (has("caps") and has("moves") and (has("lj") or has("tj") or (has("wk"))))
end

function lll_volcano()
	return has("cl")
end

function ssl_pyramid()
	return (has("cl") and (has("tj") or has("bf") or has("sf") or has("lg"))) or has("moves") or (has("wc") and has("tj")) or (has("wc") and has("ssl"))
end

function ddd_poles()
	return has("cl") and has("fskey")
end

function wdw_top()
	return (has("wk") or has("tj") or has("sf") or has("bf") or has("lj")) or has("moves")
end

function wdw_town()
	return (has("area") and has("lg") and (has("tj") or has("sf") or has("bf"))) or (has("wdw")) or (has("moves") and has("tj") and has("dv"))
end

function ttm_top()
	return (has("moves") and has("tj")) or ((has("lj") or has("dv")) and (has("lg") or has("kk"))) or (has("moves") and has("wk") and (has("sf") or has("lg"))) or (has("moves") and (has("kk") or has("dv")))
end

function thi_top()
	return has("area") or (has("lj") or has("tj") or has("dv") or has("lg")) or (has("moves") and (has("bf") or has("sf") or has("kk")))
end

function ttc_lower()
	return has("lg") or has("tj") or has("sf") or has("bf") or has("wk")
end

function ttc_upper()
	return has("cl") or (has("moves") and has("wk"))
end

function ttc_top()
	return ((has("tj")) and has("lg")) or (has("moves") and (has("wk") or has("lg")))
end

function rr_maze()
	return (has("wk")) or (has("lj") and (has("sf") or has("bf") or has("tj"))) or (has("moves") and (has("lg") or has("tj")))
end

function rr_cruiser()
	return has("wk") or has("sf") or has("bf") or has("lg") or has("tj")
end

function rr_house()
	return has("tj") or has("sf") or has("bf") or has("lg")
end

function bits_top()
	return (has("cl") and has("tj")) or (has("cl") and has("sf") and has("lg")) or (has("moves") and has("tj") and has("wk") and has("lg"))
end
