local A = {}
assert(loadfile("Interface/AddOns/CompanionJournal/JournalPagination.lua"))("CompanionJournal", A)
local count = 0
local function check(ok, message) count = count + 1; assert(ok, message) end
-- Mixed font sizes, a drop cap overlapping two rows, and a long paragraph.
local lines = {{0, 45}, {4, 18}, {24, 38}}
for i = 1, 90 do lines[#lines + 1] = {50 + i * 20, 64 + i * 20} end
for _, height in ipairs({180, 320, 500}) do
    local pages = A.JournalPageSlices(1880, height, lines, {0, 430, 910, 1450})
    check(#pages > 1, "long chapter continues over multiple pages")
    local nextOffset = 0
    for _, page in ipairs(pages) do
        check(page.offset == nextOffset, "pages neither skip nor duplicate content")
        check(page.extent > 0 and page.extent <= height, "page stays in viewport")
        nextOffset = page.offset + page.extent
        for _, line in ipairs(lines) do
            check(not (line[1] < nextOffset and line[2] > nextOffset), "no line or drop cap is cut")
        end
    end
    check(nextOffset == 1880, "final line is reachable")
end
local short = A.JournalPageSlices(70, 300, {{0, 14}, {20, 34}}, {})
check(#short == 1 and short[1].extent == 70, "short entry remains a single page")
-- Only the opening leaf reserves height for a plate or cameo. Subsequent
-- leaves reclaim that height without changing the measured text offsets.
local varied = A.JournalPageSlices(1880, 173, lines, {}, 400)
local nextOffset = 0
for i, page in ipairs(varied) do
    check(page.offset == nextOffset, "variable capacities neither skip nor duplicate text")
    check(page.extent <= (i == 1 and 173 or 400), "opening and continuation leaves use their own capacity")
    nextOffset = page.offset + page.extent
    for _, line in ipairs(lines) do
        check(not (line[1] < nextOffset and line[2] > nextOffset), "variable capacities preserve whole rendered lines")
    end
end
check(nextOffset == 1880, "variable capacities reach the last text")
check(varied[2].extent > 173, "continuation reclaims the portrait's vertical space")
check(#varied < #A.JournalPageSlices(1880, 173, lines, {}), "portrait does not reserve space on every continuation")
local widow = A.JournalPageSlices(115, 100, {{0,15},{20,35},{60,75},{80,95},{100,115}}, {0,60})
check(widow[1].extent == 80 and widow[2].offset == 80, "final two paragraph rows stay together")
local orphan = A.JournalPageSlices(155, 100, {{0,15},{20,35},{60,75},{100,115},{120,135},{140,155}}, {0,60})
check(orphan[1].extent == 60 and orphan[2].offset == 60, "first paragraph row is not stranded")
local unsafeRows = {{0,20},{30,50},{75,90},{95,110},{130,145},{150,165}}
for _, leaf in ipairs(A.JournalPageSlices(165, 120, unsafeRows, {80})) do
    local edge = leaf.offset + leaf.extent
    for _, row in ipairs(unsafeRows) do check(not (row[1] < edge and row[2] > edge), "orphan control never trusts a boundary inside text") end
end
local touching = {}
for i = 0, 99 do touching[#touching + 1] = {i * 14, (i + 1) * 14} end
local pages = A.JournalPageSlices(1400, 173, touching, {169, 700})
for _, page in ipairs(pages) do
    check(page.offset % 14 == 0, "zero-spacing paragraphs break at actual line boundaries")
    check((page.offset + page.extent) % 14 == 0, "unsafe preferred boundaries cannot split a line")
end
print("PASS: " .. count .. " pagination assertions")
