-- Reuse the actual card manager, per-character NPC views and picker callbacks.
local root, checks, named = "Interface/AddOns/CompanionJournal/", 0, {}
local function check(ok, why) checks = checks + 1; assert(ok, why) end
local M = {}; M.__index = M
local function object(parent) return setmetatable({parent=parent,scripts={},shown=true,enabled=true,width=400,height=500,children={},text=''},M) end
function M:GetParent() return self.parent end
function M:SetParent(v) self.parent=v end
function M:SetScript(k,v) self.scripts[k]=v end
function M:GetScript(k) return self.scripts[k] end
function M:GetFrameLevel() return 5 end
function M:GetWidth() return self.width end
function M:GetHeight() return self.height end
function M:SetSize(w,h) self.width,self.height=w,h end
function M:SetWidth(w) self.width=w end
function M:SetHeight(h) self.height=h end
function M:SetPoint(...) self.point={...} end
function M:ClearAllPoints() self.point=nil end
function M:SetText(v) self.text=v; if self.label then self.label.text=v end end
function M:SetTextColor(...) self.textColor={...} end
function M:GetText() return self.text end
function M:GetFontString() return self.label end
function M:SetFontString(label) self.label=label end
function M:SetColorTexture(...) self.color={...} end
function M:SetVertexColor(...) self.tint={...} end
function M:SetTexture(v) self.texture=v end
function M:SetScale(v) self.scale=v end
function M:SetEnabled(v) self.enabled=v end
function M:IsEnabled() return self.enabled end
function M:Show() self.shown=true end
function M:IsShown() return self.shown end
function M:Hide() local was=self.shown; self.shown=false; if was and self.scripts.OnHide then self.scripts.OnHide(self) end end
function M:SetShown(v) if v then self:Show() else self:Hide() end end
function M:HasFocus() return self.focused==true end
function M:ClearFocus() local had=self.focused; self.focused=false; if had and self.scripts.OnEditFocusLost then self.scripts.OnEditFocusLost(self) end end
function M:CreateTexture() local o=object(self); self.children[#self.children+1]=o; return o end
function M:CreateFontString() local o=object(self); self.children[#self.children+1]=o; return o end
for _,name in ipairs({'SetFontObject','SetNormalFontObject','SetHighlightFontObject','SetDisabledFontObject','SetJustifyH','SetWordWrap','SetShadowOffset',
    'SetFrameStrata','SetFrameLevel','EnableMouse','EnableMouseWheel','SetBackdrop','SetBackdropColor','SetAllPoints','SetAlpha','SetAutoFocus',
    'SetMaxLetters','SetClampedToScreen','RegisterEvent','UnregisterEvent'}) do M[name]=function() end end
function CreateFrame(_,name,parent)
    local f=object(parent); f.label=object(f)
    if name then named[name],_G[name]=f,f end
    return f
end
UIParent=object(); UISpecialFrames={}; SlashCmdList={}; C_Timer={After=function() end}
function time() return 1790000000 end
function date(fmt,t) return os.date(fmt,t) end
function GetNormalizedRealmName() return 'Forever' end
function GetRealmName() return 'Forever' end
local target={player=false,id=9,name='Harbor Cat'}
function UnitIsPlayer(unit) return unit=='player' or target.player end
function UnitGUID(unit) return unit=='target' and target.id and ('Creature-0-1-1-1-'..target.id..'-abc') or nil end
function UnitName(unit) return unit=='player' and 'Writer' or target.name end
local A={}
for _,file in ipairs({'Core.lua','People.lua','Characters.lua','Glyphs.lua','ColorPicker.lua','BookManagement.lua'}) do assert(loadfile(root..file))('CompanionJournal',A) end
local character='writer-forever'
A.Me=function() return character end
A.Names=function() return nil end
A.SetPersonClassIcon=function(texture) texture:Hide() end
A.PersonSummary=function(p) return p.npc and 'NPC' or 'Companion' end
local cards={['npc:1']={npc=true,name='Innkeeper',glyph='diamond',zone='Brill',note='Food and a hearthstone.'},
    ['npc:2']={npc=true,name='Trainer',glyph='star',only='alt-forever'},
    ['dahlia-forever']={name='Dahlia-Forever',glyph='heart',class='MAGE'}}
A.db={people=cards,peopleBlocked={},colors={people={.8,.2,.1},acquaintance={.7,.7,.7}},characters={
    ['writer-forever']={people={['dahlia-forever']={}}},['alt-forever']={people={}}}}
local book=object(UIParent); book.contents=object(book); book.panel=object(book)
book.contents.scroll=object(book.contents); book.panel.scroll=object(book.panel)
local manager,refreshes,closes=nil,0,0
A.RefreshBook=function() refreshes=refreshes+1; if manager and manager.left:IsShown() then manager:Refresh() end end
A.Refresh=A.RefreshBook
local close=A.ClosePersonPickers
A.ClosePersonPickers=function() closes=closes+1; close() end
manager=A.CreateBookManager(book,{npcOnly=true}); manager:Refresh()
local function button(surface,label)
    for _,b in ipairs(surface.pools.button or {}) do if b:IsShown() and b.label.text==label then return b end end
end
local function text(surface,value)
    for _,t in ipairs(surface.pools.text or {}) do if t:IsShown() and t.text==value then return t end end
end
local function click(b) check(b~=nil,'expected actionable button'); b.scripts.OnClick(b) end
local function edit(box,value) box.focused=true; box:SetText(value); box:ClearFocus() end
check(#manager.rows==1 and manager.rows[1].key=='npc:1','NPC list retains character visibility filtering')
check(not button(manager.listUI,'My characters') and not button(manager.listUI,'Companions') and not button(manager.listUI,'Add'),'NPC list hides player categories and manual add')
check(#manager.listUI.pools.edit==1,'NPC list has only the search field')
click(button(manager.listUI,'Innkeeper'))
check(manager.selected=='npc:1' and text(manager.form,'In the world'),'NPC selection opens the editable world card')
for _,label in ipairs({'Read journal','Pin','Pronouns','Spouse','Never add again','Move to'}) do check(not button(manager.form,label),'no player action on NPC card: '..label) end
check(not text(manager.form,'Your story together') and not text(manager.form,'Pronouns'),'NPC card has no relationship narrative controls')
edit(manager.form.pools.edit[1],'The Hearthkeeper')
edit(manager.form.pools.edit[2],'Buy food before leaving town.')
check(cards['npc:1'].display=='The Hearthkeeper' and cards['npc:1'].note=='Buy food before leaving town.','name and note editors update the shared NPC card')
check(button(manager.listUI,'The Hearthkeeper'),'edited display name appears in list')
click(manager.iconButton)
local glyph=named.CompanionJournalGlyphPopover
check(glyph:GetParent()==book and glyph:IsShown(),'NPC glyph picker belongs to Book B')
for _,b in ipairs(glyph.buttons) do if b.glyph=='leaf' then b.scripts.OnClick(b) end end
check(cards['npc:1'].glyph=='leaf' and manager.iconButton.icon.texture==A.GlyphPath('leaf'),'NPC glyph edit updates preview')
click(manager.colorButton)
local color=named.CompanionJournalColorPopover
check(color:GetParent()==book and color:IsShown(),'NPC color picker belongs to Book B')
color:Set(.1,.4,.7)
check(cards['npc:1'].color[3]==.7 and manager.colorButton.swatch.color[2]==.4,'NPC color previews live')
color:Cancel()
check(cards['npc:1'].color==nil and manager.colorButton.swatch.color[1]==.8,'color cancellation restores inherited NPC color')
click(manager.colorButton); color:Set(.3,.6,.9); color.done.scripts.OnClick(color.done)
check(cards['npc:1'].color[1]==.3,'NPC color commit persists')
click(button(manager.form,'+')); check(cards['npc:1'].iconSize==16,'size control updates NPC size')
click(button(manager.form,'Auto')); check(cards['npc:1'].iconSize==nil,'automatic size clears custom size')
click(button(manager.form,'This character'))
check(cards['npc:1'].only=='writer-forever','visibility choice uses actual SetNPCOnlyHere')
character='alt-forever'; manager:Refresh()
check(#manager.rows==1 and manager.rows[1].key=='npc:2' and not button(manager.form,'Remove'),'character-only card is hidden on another character')
character='writer-forever'; manager:Refresh()
check(manager.selected=='npc:1' and button(manager.form,'Remove'),'NPC selection survives visibility filtering and return')
click(button(manager.form,'All characters')); check(cards['npc:1'].only==nil,'all characters clears owner restriction')

-- Both mouse and gamepad use this guarded manager action.
local adds=0; local addTarget=A.AddTargetPerson
A.AddTargetPerson=function(...) adds=adds+1; return addTarget(...) end
target.player=true; manager:AddTarget()
check(adds==0 and not cards['npc:9'],'NPC target action rejects players before calling AddTargetPerson')
target.player=false; target.id=nil; manager:AddTarget(); check(adds==0,'missing/invalid NPC target rejected')
target.id=9; click(manager.targetButton)
check(adds==1 and cards['npc:9'] and cards['npc:9'].npc and manager.selected=='npc:9','real NPC target add creates and selects NPC card')
manager:Select('dahlia-forever','companion','others'); manager:Refresh()
check(manager.selected==nil and manager.mode=='here' and manager.circle=='npc','NPC manager cannot select a player or leave its locked category')
edit(manager.listUI.pools.edit[1],'hearth')
check(#manager.rows==1 and manager.rows[1].key=='npc:1','NPC search matches edited display names')
edit(manager.listUI.pools.edit[1],''); manager:Select('npc:9'); manager:Refresh()
click(button(manager.form,'Remove')); check(cards['npc:9']~=nil,'first remove click asks for confirmation')
click(button(manager.form,'Confirm remove')); check(cards['npc:9']==nil and manager.selected==nil,'confirmed removal deletes selected NPC')

manager:Select('npc:1'); manager:Refresh(); click(manager.colorButton); color:Set(.9,.9,.9)
manager.form.pools.edit[2].focused=true; manager.form.pools.edit[2]:SetText('Remembered on closing.')
manager:Hide()
check(not manager.left:IsShown() and not manager.right:IsShown() and not color:IsShown(),'leaving NPC manager closes both cards and pickers')
check(cards['npc:1'].color[1]==.3 and cards['npc:1'].note=='Remembered on closing.','leaving cancels color preview and commits focused note')
manager:Refresh(); check(manager.selected=='npc:1','selected NPC persists on reopening')
for id=20,29 do cards['npc:'..id]={npc=true,name='Noted NPC '..id,glyph='diamond'} end
manager:Refresh()
local function rowCount(surface)
    local n=0; for _,b in ipairs(surface.pools.button) do if b:IsShown() and b.height==33 then n=n+1 end end; return n
end
check(#manager.rows==11 and rowCount(manager.listUI)==8,'NPC list is paged with eight visible card rows')
manager.page=2; manager:Refresh()
check(rowCount(manager.listUI)==3 and button(manager.listUI,'<'):IsEnabled(),'second NPC page exposes remaining cards and back action')
click(button(manager.listUI,'<')); check(manager.page==1,'NPC page action returns to the first page')

local companion=A.CreateBookManager(book,{IsPinned=function() return false end,TogglePin=function() end})
manager=companion; companion:Refresh()
check(button(companion.listUI,'My characters') and button(companion.listUI,'Companions') and button(companion.listUI,'Add'),'companion list retains categories, character switching and manual add')
click(button(companion.listUI,'Dahlia-Forever'))
check(button(companion.form,'Read journal') and button(companion.form,'Pin') and text(companion.form,'Your story together'),'companion card retains journal and relationship controls')
check(closes>0 and refreshes>10,'manager interactions refresh cards and close inactive pickers')
local pronouns=button(companion.form,'They')
check(pronouns.height==20 and pronouns.width<48 and pronouns.edges[1].color[1]==1,'compact About-style selected control has thin gold edge')
check(companion.targetButton.fill.color[4]==1 and companion.targetButton.height==20,'manager actions use flat compact opaque controls')
for _,row in ipairs(companion.listUI.pools.button) do
    if row:IsShown() and row.label.text=='Dahlia-Forever' then check(not row.edges[1]:IsShown() and row.height==33,'list row styling stays distinct from choice controls') end
end

-- Exercise the production NPC view hook; it must reach the same editor rather
-- than the old read-only note section, and keep its selection on each refresh.
assert(loadfile(root..'JournalBookUI.lua'))('CompanionJournal',A)
local function upvalue(fn,name,replacement)
    for i=1,100 do
        local key,value=debug.getupvalue(fn,i)
        if not key then break end
        if key==name then if replacement~=nil then debug.setupvalue(fn,i,replacement) end; return value end
    end
    error('Missing book hook: '..name)
end
local fillNPCs=upvalue(A.RefreshBook,'FillNPCs')
local state=upvalue(A.RefreshBook,'state')
upvalue(A.RefreshBook,'book',book)
book.sections={old=object(book.panel)}; state.npc='npc:1'
fillNPCs()
check(book.npcManager and book.npcManager.npcOnly and book.npcManager.selected=='npc:1','NPC bookmark production hook reaches editable locked manager')
check(not book.sections.old:IsShown() and book.npcManager.left:IsShown() and book.npcManager.right:IsShown(),'NPC hook hides stale sections and shows both manager leaves')
check(button(book.npcManager.form,'Remove') and text(book.npcManager.form,'In the world'),'production NPC card exposes editor actions')
fillNPCs(); check(state.npc=='npc:1','NPC view refresh retains selection')
print('BookNPCManagement: '..checks..' checks passed')
