SELECT 	
	_FIVETRAN_ID,
	ITEM_VIEW_AT AS ITEM_VIEW_AT_TS,
	PRICE_PER_UNIT,
	REMOVE_FROM_CART_QUANTITY,
	ITEM_NAME,
	ADD_TO_CART_QUANTITY,
	SESSION_ID,
	_FIVETRAN_DELETED,
	_FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS

FROM {{source('web_schema', 'item_views')}}