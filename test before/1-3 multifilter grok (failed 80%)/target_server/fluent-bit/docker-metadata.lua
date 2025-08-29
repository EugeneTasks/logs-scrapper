-- docker-metadata.lua

DOCKER_VAR_DIR = '/var/lib/docker/containers/'
DOCKER_CONTAINER_CONFIG_FILE = '/config.v2.json'
CACHE_TTL_SEC = 300
-- ИЗМЕНЕНИЕ: Убираем префикс "docker."
DOCKER_CONTAINER_METADATA = {
  ['container_name'] = '\"Name\":\"/?(.-)\"',
  ['container_image'] = '\"Image\":\"/?(.-)\"'
  -- Убираем 'StartedAt', он редко нужен как метка
}
cache = {}

function get_container_id_from_tag(tag)
  -- ИЗМЕНЕНИЕ: Более надежный regex, который точно берет ID
  return tag:match('.+/([a-f0-9]+)%-json%.log$')
end

function get_container_metadata_from_disk(container_id)
  local docker_config_file = DOCKER_VAR_DIR .. container_id .. DOCKER_CONTAINER_CONFIG_FILE
  fl = io.open(docker_config_file, 'r')
  if fl == nil then
    return nil
  end

  local data = { time = os.time() }
  local file_content = fl:read("*a")
  fl:close()

  for key, regex in pairs(DOCKER_CONTAINER_METADATA) do
    local match = file_content:match(regex)
    if match then
      data[key] = match
    end
  end

  if next(data) == nil then
    return nil
  else
    return data
  end
end

function encrich_with_docker_metadata(tag, timestamp, record)
  container_id = get_container_id_from_tag(tag)
  if not container_id then
    return 0, 0, 0
  end

  new_record = record
  -- ИЗМЕНЕНИЕ: Убираем префикс "docker."
  new_record['container_id'] = container_id

  local cached_data = cache[container_id]
  if cached_data == nil or ( os.time() - cached_data['time'] > CACHE_TTL_SEC) then
    cached_data = get_container_metadata_from_disk(container_id)
    cache[container_id] = cached_data
  end

  if cached_data then
    for key, value in pairs(cached_data) do
      new_record[key] = value
    end
  end

  return 1, timestamp, new_record
end