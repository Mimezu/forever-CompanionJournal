local _, A = ...
-- Page boundaries use the actual rendered line boxes. Never cut through text;
-- prefer a paragraph boundary when that still fills most of the page.
function A.JournalPageSlices(height, capacity, lines, paragraphs, continuationCapacity)
    capacity = math.max(60, capacity or 400)
    continuationCapacity = math.max(60, continuationCapacity or capacity)
    local occupied = {}
    table.sort(lines, function(a, b) return a[1] < b[1] end)
    for _, line in ipairs(lines) do
        local last = occupied[#occupied]
        if last and line[1] < last[2] - 0.01 then last[2] = math.max(last[2], line[2])
        else occupied[#occupied + 1] = {line[1], line[2]} end
    end
    local starts = {0}
    for _, point in ipairs(paragraphs or {}) do if point > 0 and point < height then starts[#starts + 1] = point end end
    table.sort(starts)
    starts[#starts + 1] = height
    local pages, from = {}, 0
    repeat
        local pageCapacity = #pages == 0 and capacity or continuationCapacity
        local edge = math.min(height, from + pageCapacity)
        if edge < height then
            for _, line in ipairs(occupied) do
                if line[1] < edge and line[2] > edge then edge = line[1]; break end
            end
            local preferred
            for _, point in ipairs(paragraphs or {}) do
                if point > from + pageCapacity * 0.65 and point <= edge then
                    local safe = true
                    for _, line in ipairs(occupied) do if line[1] < point and line[2] > point then safe = false; break end end
                    if safe then preferred = math.max(preferred or 0, point) end
                end
            end
            if preferred then edge = preferred end
            -- At a necessary split inside a paragraph, leave at least two
            -- complete text rows on either side where the page has room.
            -- This avoids an isolated first or final line without dropping
            -- text or forcing every short paragraph onto a separate page.
            for i = 1, #starts - 1 do
                local first, last = starts[i], starts[i + 1]
                if edge > first and edge < last then
                    local before, after = {}, {}
                    for _, row in ipairs(occupied) do
                        if row[1] >= first and row[2] <= last then
                            if row[2] <= edge and row[1] >= from then before[#before + 1] = row
                            elseif row[1] >= edge then after[#after + 1] = row end
                        end
                    end
                    if #before == 1 and #after > 0 and first > from + 1 then
                        local safe = true
                        for _, row in ipairs(occupied) do if row[1] < first and row[2] > first then safe = false; break end end
                        if safe then edge = first end
                    elseif #before >= 2 and #after == 1 and before[#before][1] > from + 1 then
                        edge = before[#before][1]
                    end
                    break
                end
            end
        end
        -- A malformed oversized font cannot stall pagination indefinitely.
        if edge <= from + 1 then edge = math.min(height, from + pageCapacity) end
        pages[#pages + 1] = {offset = from, extent = math.max(1, edge - from)}
        from = edge
    until from >= height
    return pages
end
