function drop_fluentbit_logs(tag, timestamp, record)
    if record and record['log'] and record['log']['attrs'] and record['log']['attrs']['tag'] then
        if record['log']['attrs']['tag'] == 'fluent-bit' then
            return -1, 0, 0 
        end
    end
    return 0, timestamp, record
end