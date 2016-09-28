# TIMEFORMAT
module TimeFormat
  def seconds_to_units(seconds)
    '[%d days, %d hours, %d minutes, %d seconds]' %
      # the .reverse lets us put the larger units first for readability
      [24, 60, 60].reverse.inject([seconds]) do |result, unitsize|
        result[0, 0] = result.shift.divmod(unitsize)
        result
      end
  end
end
