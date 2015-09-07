require "fileutils"

built_products_dir = ENV.fetch("BUILT_PRODUCTS_DIR") { fail "BUILT_PRODUCTS_DIR not set" }
STDOUT.puts "[RP] built_products_dir : #{built_products_dir}"
input_file_count = ENV.fetch("SCRIPT_INPUT_FILE_COUNT") { fail "SCRIPT_INPUT_FILE_COUNT not set" }.to_i

framework_files = input_file_count.times.map { |i|
    ENV.fetch("SCRIPT_INPUT_FILE_#{i}") { fail "SCRIPT_INPUT_FILE_#{i} not set" }
}

dsym_file_names = framework_files.map { |f|
    "#{f}.dSYM"
}

dsym_files = dsym_file_names.select { |dsym|
    File.directory?(dsym)
}


dsym_files.each do |dsym|
    STDOUT.puts "[RP] dsym : #{dsym}"
    FileUtils.cp_r(dsym, "#{built_products_dir}/")
end