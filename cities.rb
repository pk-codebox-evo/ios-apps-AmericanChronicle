require 'csv'
require 'set'




class CensusRow
    
    attr_accessor :geographic_summary_level
    attr_accessor :state_fips
    attr_accessor :county_fips
    attr_accessor :place_fips
    attr_accessor :minor_civil_division_fips
    attr_accessor :consolidated_city_fips
    attr_accessor :primitive_geography
    attr_accessor :functional_status_code
    attr_accessor :area_name
    attr_accessor :state_name
    attr_accessor :population

    COUNTY_FIPS_NONE = "000"

    # Source: http://www.census.gov/popest/data/cities/totals/2014/files/SUB-EST2014.pdf
    SUMLEV_STATE = "040"
    SUMLEV_COUNTY = "050"
    SUMLEV_MINOR_CIVIL_DIVISION = "61"
    SUMLEV_MINOR_CIVIL_DIVISION_PLACE_PART = "071"
    SUMLEV_COUNTY_PLACE_PART = "157" 
    SUMLEV_INCORPORATED_PLACE = "162" 
    SUMLEV_CONSOLIDATED_CITY = "170" 
    SUMLEV_CONSOLIDATED_CITY_PART = "172"

    STATE_FIPS_COLORADO = "08"

    def initialize(csv_row)
        @geographic_summary_level = csv_row.fetch(0)
        @state_fips = csv_row.fetch(1)
        @county_fips = csv_row.fetch(2)
        @place_fips = csv_row.fetch(3)
        @minor_civil_division_fips = csv_row.fetch(4)
        @consolidated_city_fips = csv_row.fetch(5)
        @primitive_geography = csv_row.fetch(6)
        @functional_status_code = csv_row.fetch(7)
        @area_name = csv_row.fetch(8)
        @state_name = csv_row.fetch(9)
        @population = csv_row.fetch(10)
    end

    def geographic_summary_level_description()
        return case @geographic_summary_level
        when SUMLEV_STATE
            "State"
        when SUMLEV_COUNTY
            "County"
        when SUMLEV_MINOR_CIVIL_DIVISION
            "Minor Civil Division"
        when SUMLEV_MINOR_CIVIL_DIVISION_PLACE_PART
            "Minor Civil Division Place Part"
        when SUMLEV_COUNTY_PLACE_PART
            "County Place Part"
        when SUMLEV_INCORPORATED_PLACE
            "Incorporated Place"
        when SUMLEV_CONSOLIDATED_CITY
            "Consolidated City"
        when SUMLEV_CONSOLIDATED_CITY_PART
            "Consolidated City Part"
        end
    end
end

full_file_path = "/Users/ryanipete/ryanipete/AmericanChronicle/AmericanChronicle/cities_2014.csv"
all_rows = Array.new
file = File.open(full_file_path)

1.times { file.gets } # Get rid of header line

file.each do |line|
    begin
        row = CSV.parse(line.scrub)[0]
        row_obj = CensusRow.new(row)
        all_rows.push(row_obj)
    rescue
        STDOUT.puts "[RP] Trouble parsing line : '#{line}'"
    end
end

unique_sumlev = Set.new(all_rows.map { |row| row.geographic_summary_level })
STDOUT.puts "[RP] unique_sumlev.count : #{unique_sumlev.count}"
unique_sumlev.each do |sumlev|
    STDOUT.puts "[RP] sumlev : #{sumlev}"
end

colorado_rows = all_rows.select { |row| row.state_fips.eql?(CensusRow::STATE_FIPS_COLORADO) }
colorado_county_rows = colorado_rows.select { |row| row.geographic_summary_level.eql?(CensusRow::SUMLEV_COUNTY) }
colorado_county_rows.each do |county_row|
    # STDOUT.puts "#{county_row.area_name} [#{county_row.population}]"
    rows_in_county = colorado_rows.select { |row| row.county_fips.eql?(county_row.county_fips) && !row.geographic_summary_level.eql?(CensusRow::SUMLEV_COUNTY) }
    rows_in_county_total_pop = 0
    rows_in_county.each do |county_place_row|
        # STDOUT.puts " | #{county_place_row.area_name} (#{county_place_row.geographic_summary_level_description}) [#{county_place_row.population}]"
        rows_in_county_total_pop += county_place_row.population.to_i
    end
    # STDOUT.puts " | Total [#{rows_in_county_total_pop}]"

    if county_row.population.to_i == rows_in_county_total_pop
        STDOUT.puts "#{county_row.area_name} | Populations match"
    else
        STDOUT.puts "#{county_row.area_name} | ERROR: Populations don't match (county's is #{county_row.population}, sum of places is #{rows_in_county_total_pop})"
    end

end
