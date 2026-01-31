# Date & Time
ts = time()
print("Timestamp:", ts)
print("Year:", year(ts))
print("Month:", month(ts))
print("Day:", day(ts))

formatted = date_format(ts, "%Y-%m-%d %H:%M:%S")
print("Formatted:", formatted)
