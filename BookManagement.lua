local _, A = ...
-- A compact card on each parchment leaf. The logical page is fixed; both
-- leaves scale together to fit the book, so no control is lost below a scroll.
local INK, SOFT = {0.20,0.11,0.04}, {0.36,0.22,0.08}
-- The sheet's design size. At bigger book sizes it is not magnified: it keeps its scale
-- (1, or less on a small book) and grows to the page, with the extra room below the list.
local BASE_W, BASE_H = 360, 448
local PW, PH = BASE_W, BASE_H
local categories = {{'companion','Companions',88},{'acquaintance','Acquaintances',106},{'campfire','Campfire',76},{'rival','Rivals',78}}
-- The same flat leather switches as the journal's About card. Settings and
-- managers share this small control without a Blizzard bevel or a larger panel.
function A.StyleBookControl(button, chosen)
    if not button.bookStateHooks and button.HookScript then
        button.bookStateHooks = true
        local function Enabled(self) self:SetAlpha(self:IsEnabled() and 1 or 0.45) end
        button:HookScript('OnEnable', Enabled); button:HookScript('OnDisable', Enabled)
        Enabled(button)
    end
    if not button.fill then button.fill=button:CreateTexture(nil,'BACKGROUND') end
    button.fill:ClearAllPoints(); button.fill:SetAllPoints()
    button.fill:SetColorTexture(chosen and .29 or .18,chosen and .20 or .13,chosen and .06 or .07,1)
    if not button.edges then
        button.edges={}
        for _,side in ipairs({'TOP','BOTTOM','LEFT','RIGHT'}) do
            local edge=button:CreateTexture(nil,'BORDER')
            if side=='TOP' or side=='BOTTOM' then edge:SetPoint(side..'LEFT'); edge:SetPoint(side..'RIGHT'); edge:SetHeight(1)
            else edge:SetPoint('TOP'..side); edge:SetPoint('BOTTOM'..side); edge:SetWidth(1) end
            button.edges[#button.edges+1]=edge
        end
        local hover=button:CreateTexture(nil,'HIGHLIGHT'); hover:SetAllPoints(); hover:SetColorTexture(1,.7,.2,.12)
    end
    for _,edge in ipairs(button.edges) do edge:SetColorTexture(chosen and 1 or .42,chosen and .82 or .32,chosen and 0 or .19,1); edge:Show() end
    if button.label then
        button.label:SetFontObject('GameFontHighlightSmall')
        button.labelColor=chosen and {1,.82,0} or {.91,.85,.69}
        button.label:SetTextColor(unpack(button.labelColor))
        if button.label.SetShadowOffset then button.label:SetShadowOffset(0,0) end
    end
end
local function Tip(control, text)
    control:SetScript('OnEnter',function(self)
        if self.label and self.labelColor and self:IsEnabled() then self.label:SetTextColor(unpack(self.labelColor)) end
        if GameTooltip and text then GameTooltip:SetOwner(self,'ANCHOR_RIGHT'); GameTooltip:SetText(text,1,1,1,1,true); GameTooltip:Show() end
    end)
    control:SetScript('OnLeave',function(self)
        if self.label and self.labelColor and self:IsEnabled() then self.label:SetTextColor(unpack(self.labelColor)) end
        if GameTooltip then GameTooltip:Hide() end
    end)
end
local function Surface(parent)
    local s={parent=parent,pools={},used={},width=PW}
    function s:Take(kind)
        self.used[kind]=(self.used[kind] or 0)+1
        local pool=self.pools[kind] or {}; self.pools[kind]=pool
        local c=pool[self.used[kind]]
        if not c then
            if kind=='text' then
                c=parent:CreateFontString(nil,'ARTWORK','GameFontHighlight'); c:SetJustifyH('LEFT'); c:SetWordWrap(false)
                if c.SetShadowOffset then c:SetShadowOffset(0,0) end
            elseif kind=='edit' then
                c=CreateFrame('EditBox',nil,parent,'InputBoxTemplate'); c:SetAutoFocus(false)
                c:SetScript('OnEscapePressed',function(box) box:ClearFocus() end)
            elseif kind=='rule' then
                c=parent:CreateTexture(nil,'ARTWORK'); c:SetColorTexture(.42,.26,.09,.35)
            else
                c=CreateFrame('Button',nil,parent)
                c.label=c:CreateFontString(nil,'ARTWORK','GameFontHighlightSmall'); c:SetFontString(c.label)
                A.StyleBookControl(c,false)
                c.icon=c:CreateTexture(nil,'ARTWORK'); c.icon:SetSize(22,22); c.icon:SetPoint('LEFT',5,0)
                c.classIcon=c:CreateTexture(nil,'ARTWORK'); c.classIcon:SetSize(20,20); c.classIcon:SetPoint('RIGHT',-5,0)
                c.swatch=c:CreateTexture(nil,'ARTWORK'); c.swatch:SetPoint('TOPLEFT',5,-5); c.swatch:SetPoint('BOTTOMRIGHT',-5,5)
                c.sub=c:CreateFontString(nil,'ARTWORK','GameFontHighlightSmall'); c.sub:SetJustifyH('LEFT'); c.sub:SetTextColor(unpack(SOFT)); c.sub:SetWordWrap(false)
                if c.sub.SetShadowOffset then c.sub:SetShadowOffset(0,0) end
                c.focus=c:CreateTexture(nil,'OVERLAY'); c.focus:SetPoint('TOPLEFT'); c.focus:SetPoint('BOTTOMLEFT'); c.focus:SetWidth(2); c.focus:SetColorTexture(.65,.38,.08,1); c.focus:Hide()
            end
            pool[self.used[kind]]=c
        end
        c:ClearAllPoints(); c:Show(); return c
    end
    function s:Begin() self.used={} end
    function s:Finish()
        for kind,pool in pairs(self.pools) do for i=(self.used[kind] or 0)+1,#pool do pool[i]:Hide() end end
    end
    function s:Blur() for _,box in ipairs(self.pools.edit or {}) do box:ClearFocus() end end
    function s:Text(text,x,y,w,font)
        local c=self:Take('text'); c:SetJustifyH('LEFT'); c:SetWordWrap(false); c:SetFontObject(font or 'GameFontHighlightSmall'); c:SetTextColor(unpack(INK))
        c:SetPoint('TOPLEFT',x,-y); c:SetWidth(w or PW-x); c:SetHeight(font=='GameFontNormalLarge' and 22 or 16); c:SetText(text or ''); return c
    end
    function s:Rule(y) local c=self:Take('rule'); c:SetPoint('TOPLEFT',0,-y); c:SetSize(PW,1) end
    function s:Button(label,x,y,w,action,chosen)
        local c=self:Take('button'); c:SetPoint('TOPLEFT',x,-y); c:SetSize(w,20)
        -- Template hover/disabled states otherwise restore a larger font,
        -- making labels jump in size as the pointer moves between controls.
        c:SetNormalFontObject('GameFontNormalSmall'); c:SetHighlightFontObject('GameFontHighlightSmall'); c:SetDisabledFontObject('GameFontDisableSmall')
        c:SetEnabled(true); c:SetText(label); A.StyleBookControl(c,chosen)
        c.label:ClearAllPoints(); c.label:SetPoint('LEFT',4,0); c.label:SetPoint('RIGHT',-4,0); c.label:SetJustifyH('CENTER'); c.label:SetWordWrap(false)
        c.icon:ClearAllPoints(); c.icon:SetPoint('LEFT',5,0); c.icon:SetSize(22,22); c.icon:Hide(); c.classIcon:Hide(); c.sub:Hide(); c.swatch:Hide(); c.focus:Hide()
        c:SetScript('OnClick',action); c:SetScript('OnDoubleClick',nil); Tip(c,nil); return c
    end
    function s:Choices(items,value,x,y,w,set)
        local total=0; for _,v in ipairs(items) do total=total+(v[3] or #v[2]*6+16) end
        local available=w-(#items-1)*4
        for _,v in ipairs(items) do
            local width=available*(v[3] or #v[2]*6+16)/total
            self:Button(v[2],x,y,width,function() set(v[1]); A.RefreshBook() end,value==v[1]); x=x+width+4
        end
    end
    function s:Edit(value,x,y,w,save,limit,hint)
        local c=self:Take('edit'); c:SetPoint('TOPLEFT',x+6,-y); c:SetSize(w-6,22); c:SetMaxLetters(limit or 200)
        if not c:HasFocus() then c:SetText(value or '') end
        c:SetScript('OnTextChanged',nil)
        c:SetScript('OnEnterPressed',function(box) box:ClearFocus() end)
        c:SetScript('OnEditFocusLost',function(box)
            local text=(box:GetText() or ''):gsub('^%s+',''):gsub('%s+$','')
            if text~=(value or '') then save(text~='' and text or nil) end
        end)
        Tip(c,hint)
        if hint and (value or '')=='' then
            if not c.hint then c.hint=c:CreateFontString(nil,'OVERLAY','GameFontDisableSmall'); c.hint:SetPoint('LEFT',4,0); c.hint:SetJustifyH('LEFT') end
            c.hint:SetWidth(w-16); c.hint:SetText(hint); c.hint:Show()
        elseif c.hint then c.hint:Hide() end
        c:SetScript('OnTextChanged',function(box) if box.hint then box.hint:SetShown((box:GetText() or '')=='') end end)
        return c
    end
    return s
end
function A.CreateBookManager(book,kit)
    local m={mode='here',circle=kit.npcOnly and 'npc' or 'companion',page=1,query='',npcOnly=kit.npcOnly==true}
    m.left=CreateFrame('Frame',nil,book.contents); m.left:SetSize(PW,PH)
    m.right=CreateFrame('Frame',nil,book.panel); m.right:SetSize(PW,PH)
    m.left:SetFrameLevel(book.contents:GetFrameLevel()+3); m.right:SetFrameLevel(book.panel:GetFrameLevel()+3)
    m.listUI,m.form=Surface(m.left),Surface(m.right)
    function m:FinishEditing()
        if A.ClosePersonPickers then A.ClosePersonPickers() end
        self.form:Blur()
    end
    m.left:EnableMouseWheel(true); m.left:SetScript('OnMouseWheel',function(_,d) m.page=m.page+(d>0 and -1 or 1); A.RefreshBook() end)
    function m:Select(key,circle,mode)
        self:FinishEditing(); self.selected,self.armed,self.ownerIndex=key,nil,1
        if self.npcOnly then
            self.mode,self.circle='here','npc'
            if key and (not A.People[key] or not A.People[key].npc) then self.selected=nil end
            if self.selected then self.query,self.page,self.reveal='',1,self.selected end
            return
        end
        if mode then self.mode=mode end
        if key and not mode and A.People[key] then self.mode='here' end
        if circle then self.circle,self.mode=circle,'here' end
        if key then self.query,self.page,self.reveal='',1,key end
        if key and not A.People[key] and not (A.db.peopleBlocked or {})[key] then self.mode='others' end
        if key and self.mode=='here' and A.People[key] then self.circle=A.PersonCircle(A.People[key]) end
    end
    function m:Hide()
        if self.left:IsShown() then self:FinishEditing(); self.listUI:Blur() end
        self.left:Hide(); self.right:Hide()
    end
    function m:Rows()
        local list={}
        if self.npcOnly then for key,p in A.EachPerson() do if p.npc then list[#list+1]={key=key,card=p} end end
        elseif self.mode=='others' then list=A.OthersPeople(self.character)
        elseif self.circle=='blocked' then for key,p in pairs(A.db.peopleBlocked or {}) do list[#list+1]={key=key,card=p} end
        else for key,p in A.EachPerson() do if (self.circle=='all' and not p.npc) or A.PersonCircle(p)==self.circle then list[#list+1]={key=key,card=p} end end end
        local filtered={}
        for _,r in ipairs(list) do if ((r.card.display or '')..' '..(r.card.name or r.key)):lower():find(self.query:lower(),1,true) then filtered[#filtered+1]=r end end
        table.sort(filtered,function(a,b) return (a.card.display or a.card.name or a.key):lower()<(b.card.display or b.card.name or b.key):lower() end)
        return filtered
    end
    function m:AddTarget()
        if self.npcOnly then
            local ok,player=pcall(UnitIsPlayer,'target')
            if not ok or (issecretvalue and issecretvalue(player)) or player~=false or not (A.NPCID and A.NPCID('target')) then
                print('Companion Journal: target an NPC first.'); return
            end
        end
        self:FinishEditing()
        local p,k=A.AddTargetPerson()
        if p and k then self:Select(k) end
        A.RefreshBook()
        return p,k
    end
    function m:Refresh()
        if self.npcOnly then self.mode,self.circle='here','npc' end
        book.contents.scroll:Hide(); book.panel.scroll:Hide()
        -- (margins clear of the pages' printed corners: 32 a side, 22 on top, 56 below)
        local roomW=math.min(book.contents:GetWidth(),book.panel:GetWidth())-64
        local roomH=math.min(book.contents:GetHeight(),book.panel:GetHeight())-78
        local scale=math.min(1,roomW/BASE_W,roomH/BASE_H)
        PW,PH=math.floor(roomW/scale),math.floor(roomH/scale)
        for _,surface in ipairs({self.left,self.right}) do
            surface:SetScale(scale); surface:SetSize(PW,PH); surface:ClearAllPoints()
            surface:SetPoint('TOP',surface:GetParent(),'TOP',0,-22/scale); surface:Show()
        end
        local low=PH-BASE_H
        local s=self.listUI; s:Begin()
        s:Text((self.npcOnly or self.circle=='npc') and 'NPCs' or 'Companions',0,0,PW,'GameFontNormalLarge')
        if not self.npcOnly then s:Choices({{'here','This character'},{'others','My characters'}},self.mode,0,28,260,function(v) self:FinishEditing(); self.mode,self.selected,self.page,self.armed=v,nil,1,nil end) end
        local searchY=self.npcOnly and 38 or 60
        local search=s:Edit(self.query,0,searchY,234,function(v) self.query,self.page=v or '',1; A.RefreshBook() end,100,'Search names')
        search:SetScript('OnTextChanged',function(box,user) if box.hint then box.hint:SetShown((box:GetText() or '')=='') end; if user then self.query,self.page=box:GetText() or '',1; A.RefreshBook() end end)
        self.targetButton=s:Button(self.npcOnly and 'Add target NPC' or 'Add my target',240,searchY,120,function() self:AddTarget() end)
        if not self.npcOnly and self.mode=='here' then
            s:Choices(categories,self.circle,0,94,PW,function(v) self:FinishEditing(); self.circle,self.page,self.selected,self.armed=v,1,nil,nil end)
        elseif not self.npcOnly then
            local chars=A.OtherCharacters(); local at=0; for i,c in ipairs(chars) do if c.key==self.character then at=i end end
            s:Button((at>0 and chars[at].name or 'All other characters')..' >',0,94,PW,function() self:FinishEditing(); at=(at+1)%(#chars+1); self.character,self.selected,self.page=at>0 and chars[at].key or nil,nil,1; A.RefreshBook() end)
        end
        local list=self:Rows(); self.rows=list
        local capacity=(self.npcOnly and 8 or 7)+math.max(0,math.floor(low/35)); local pages=math.max(1,math.ceil(#list/capacity))
        if self.reveal then for i,r in ipairs(list) do if r.key==self.reveal then self.page=math.floor((i-1)/capacity)+1 end end; self.reveal=nil end
        self.page=math.max(1,math.min(pages,self.page))
        local selected; for _,r in ipairs(list) do if r.key==self.selected then selected=r end end
        for i=(self.page-1)*capacity+1,math.min(#list,self.page*capacity) do
            local r=list[i]; local p=r.card; local y=(self.npcOnly and 76 or 124)+((i-1)%capacity)*35
            local button=s:Button(p.display or p.name or r.key,0,y,PW,function() self:FinishEditing(); self.selected,self.armed,self.ownerIndex=r.key,nil,1; A.RefreshBook() end)
            button:SetHeight(33); for _,edge in ipairs(button.edges) do edge:Hide() end
            button.fill:ClearAllPoints(); button.fill:SetAllPoints(button)
            button.fill:SetColorTexture(.48,.29,.05,r.key==self.selected and .24 or .04)
            button.focus:SetShown(r.key==self.selected)
            button:SetNormalFontObject('GameFontHighlight'); button:SetHighlightFontObject('GameFontHighlight')
            button.labelColor=INK
            button.label:SetTextColor(unpack(INK)); button.label:SetFontObject('GameFontHighlight'); if button.label.SetShadowOffset then button.label:SetShadowOffset(0,0) end
            button.label:ClearAllPoints(); button.label:SetPoint('TOPLEFT',32,-3); button.label:SetSize(PW-82,14); button.label:SetJustifyH('LEFT')
            local glyph=A.IconGlyph('people',p)
            if glyph~='none' then button.icon:SetTexture(A.GlyphPath(glyph)); button.icon:SetVertexColor(unpack(A.IconColor('people',p))); button.icon:Show() end
            A.SetPersonClassIcon(button.classIcon,p.class)
            button.sub:ClearAllPoints(); button.sub:SetPoint('TOPLEFT',32,-18); button.sub:SetSize(PW-66,12)
            button.sub:SetText(self.npcOnly and ((p.only and 'This character' or 'All characters')..'  |  '..(p.zone or 'Location not recorded')) or self.circle=='blocked' and 'Never added automatically' or self.mode=='others' and r.knowers and r.knowers[1] and ('Known by '..r.knowers[1].name) or ('Last seen: '..(p.zone or 'not recorded'))); button.sub:Show()
            if p.level then s:Text(tostring(p.level),PW-54,y+7,25) end
            if not p.npc and self.circle~='blocked' then button:SetScript('OnDoubleClick',function() A.OpenBook(r.key,self.mode=='others' and r.from or nil) end) end
            Tip(button,p.name or r.key)
        end
        if #list==0 then s:Text(self.npcOnly and 'No matching NPCs.' or 'No matching people.',8,140,PW-16) end
        s:Button('<',0,384+low,28,function() self.page=self.page-1; A.RefreshBook() end):SetEnabled(self.page>1)
        local page=s:Text(self.page..' / '..pages,32,388+low,60); page:SetJustifyH('CENTER')
        s:Button('>',96,384+low,28,function() self.page=self.page+1; A.RefreshBook() end):SetEnabled(self.page<pages)
        local noun=self.npcOnly and (#list==1 and 'NPC' or 'NPCs') or self.circle=='companion' and self.mode=='here' and (#list==1 and 'companion' or 'companions') or (#list==1 and 'person' or 'people')
        local count=s:Text(#list..' '..noun,144,388+low,PW-144); count:SetJustifyH('RIGHT'); count:SetTextColor(unpack(SOFT))
        s:Rule(408+low)
        if self.npcOnly then
            s:Text('Target an NPC to add their card.',0,420+low,PW):SetTextColor(unpack(SOFT))
        else
            local add=s:Edit(self.addName,0,420+low,PW-110,function(v) self.addName=v end,80,'Name or Name-Realm')
            local function Add() local name=add:GetText(); add:ClearFocus(); if name and name:match('%S') then local p,k=A.AddPerson(name); if p and k then self.addName=nil; self:Select(k); A.RefreshBook() end end end
            add:SetScript('OnEnterPressed',Add); s:Button('Add',PW-102,420+low,102,Add)
        end
        s:Finish()
        local f=self.form; f:Begin()
        if selected then
            local key,p=selected.key,selected.card
            f:Text(p.display or p.name or key,0,0,PW-164,'GameFontNormalLarge')
            f:Text(A.PersonSummary(p),0,25,PW):SetTextColor(unpack(SOFT))
            if self.mode=='others' then
                f:Text('Known by your other characters',0,70,PW)
                local note=f:Text(p.note or 'No note.',0,106,PW); note:SetWordWrap(true); note:SetHeight(80)
                f:Button('Add to this character',0,386+low,PW,function() A.ImportPerson(key,selected.from); self:Select(key); A.RefreshBook() end):SetEnabled(selected.usable==true)
            elseif self.circle=='blocked' then
                f:Text(A.DescribeBlocked(p),0,70,PW)
                f:Button('Allow automatic adding again',0,386+low,PW,function() self.selected=nil; A.UnblockPerson(key) end)
            else
                if not p.npc then
                    f:Button('Read journal',PW-158,0,98,function() A.OpenBook(key) end)
                    local pin=f:Button(kit.IsPinned(key) and 'Pinned' or 'Pin',PW-54,0,54,function() kit.TogglePin(key); A.RefreshBook() end,kit.IsPinned(key)); Tip(pin,kit.IsPinned(key) and 'Remove their bookmark from the side of the book' or 'Keep their journal on a side bookmark (up to six)')
                end
                f:Text('Display name',0,58,88); f:Edit(p.display,94,54,PW-94,function(v) p.display=v; A.Refresh() end,60,p.name or key)
                f:Text('Icon',0,90,88)
                local glyph=f:Button('',94,86,34,function(button) A.PickGlyph(button,A.IconGlyph('people',p),A.IconColor('people',p),function(v) p.glyph=v; A.Refresh() end,true) end)
                self.iconButton=glyph
                glyph.icon:ClearAllPoints(); glyph.icon:SetPoint('CENTER'); glyph.icon:SetSize(16,16); glyph.icon:SetTexture(A.GlyphPath(A.IconGlyph('people',p))); glyph.icon:SetVertexColor(unpack(A.IconColor('people',p))); glyph.icon:SetShown(A.IconGlyph('people',p)~='none'); Tip(glyph,'Choose an icon')
                local colour=f:Button('',134,86,44,function(button) A.PickIconColor('people',button,p) end); colour.swatch:SetColorTexture(unpack(A.IconColor('people',p))); colour.swatch:Show(); Tip(colour,'Choose icon colour')
                self.colorButton=colour
                local function Step(d) p.iconSize=math.max(6,math.min(48,(p.iconSize or A.DefaultIconSize(p))+d)); A.Refresh() end
                f:Button('-',188,86,22,function() Step(-2) end); f:Text(tostring(p.iconSize or A.DefaultIconSize(p)),216,90,26)
                f:Button('+',244,86,22,function() Step(2) end); f:Button('Auto',276,86,54,function() p.iconSize=nil; A.Refresh() end)
                f:Text('Note',0,122,88); f:Edit(p.note,94,118,PW-94,function(v) p.note=v; A.Refresh() end,200,'Something to remember')
                f:Text(p.npc and 'In the world' or 'Your story together',0,154,PW,'GameFontHighlight'); f:Rule(174)
                if not p.npc then
                    f:Text('Pronouns',0,184,112); f:Choices({{'they','They',1},{'he','He',1},{'she','She',1}},p.pronouns or 'they',0,204,126,function(v) A.SetPersonPronouns(p,v) end)
                    f:Text('How it began',144,184,PW-144); f:Choices({{'road','On the road',1},{'together','Together',1}},p.origin or 'road',144,204,212,function(v) A.SetPersonStory(p,'origin',v) end)
                    f:Text('Relationship',0,244,PW)
                    f:Choices({{'none','Companion'},{'spouse','Spouse'},{'partner','Partner'},{'friend','Friend'},{'family','Family'}},p.bond or 'none',0,264,326,function(v) A.SetPersonStory(p,'bond',v) end)
                else
                    f:Text('Visible to',0,184,PW); f:Choices({{false,'All characters'},{true,'This character'}},p.only~=nil,0,204,248,function(v) A.SetNPCOnlyHere(p,v) end)
                end
                local function When(t) return t and date('%d %b %Y',t) or 'not recorded' end
                f:Text('Added: '..When(p.added),0,302,PW):SetTextColor(unpack(SOFT))
                f:Text('Met: '..(p.metZone or When(p.met)),0,318,PW):SetTextColor(unpack(SOFT))
                if p.npc or #A.OtherJournals(key)==0 then f:Text('Last seen: '..(p.zone or When(p.seen)),0,334,PW):SetTextColor(unpack(SOFT)) end
                f:Rule(362+low)
                if not p.npc then
                    local moves={}; for _,c in ipairs(categories) do if c[1]~=A.PersonCircle(p) then moves[#moves+1]={c[1],c[2]} end end
                    f:Text('Move to',0,378+low,62); f:Choices(moves,nil,66,374+low,PW-66,function(v) self.circle=v; A.MovePerson(key,v) end)
                end
                local function Remove(block)
                    local kind=block and 'block' or 'remove'
                    if self.armed~=kind then self.armed=kind; A.RefreshBook(); return end
                    self.selected,self.armed=nil,nil; if block then A.BlockPerson(key) else A.RemovePerson(key) end
                end
                local remove=f:Button(self.armed=='remove' and 'Confirm remove' or 'Remove',0,420+low,172,function() Remove(false) end); remove.fill:SetColorTexture(.27,.10,.07,1)
                if not p.npc then local block=f:Button(self.armed=='block' and 'Confirm block' or 'Never add again',PW-180,420+low,180,function() Remove(true) end); block.fill:SetColorTexture(.27,.10,.07,1) end
            end
            if not p.npc and self.circle~='blocked' then
                local owners=A.OtherJournals(key)
                if #owners>0 then
                    self.ownerIndex=math.max(1,math.min(#owners,self.ownerIndex or 1)); local owner=owners[self.ownerIndex]
                    local y=self.mode=='others' and 230 or 334
                    f:Button(owner.name..' >',0,y,172,function() self.ownerIndex=self.ownerIndex%#owners+1; A.RefreshBook() end)
                    f:Button('Read their journal',180,y,180,function() A.OpenBook(key,owner.key) end)
                end
            end
        else
            f:Text(self.npcOnly and 'Your NPCs' or 'Your companions',0,0,PW,'GameFontNormalLarge')
            local label=f:Text(self.npcOnly and 'Choose an NPC on the left to edit their name, icon, colour, note and visibility.' or 'Choose someone on the left to read their journal or edit their card.',0,48,PW); label:SetWordWrap(true); label:SetHeight(60)
            local detail=f:Text(self.npcOnly and 'Share an NPC card across your characters, or keep it just for this one.' or 'Their settings shape your story together.',0,128,PW)
            if self.npcOnly then detail:SetWordWrap(true); detail:SetHeight(40) end
        end
        if self.mode=='others' then
            local ready=0; for _,r in ipairs(A.OthersPeople(self.character)) do if r.usable and (r.rel.circle or 'companion')=='companion' then ready=ready+1 end end
            if ready>0 then f:Button(self.armed=='import' and ('Confirm adding '..ready) or ('Add all companions ('..ready..')'),0,420+low,PW,function() if self.armed~='import' then self.armed='import'; A.RefreshBook(); return end; self.armed=nil; A.ImportFrom(self.character); A.RefreshBook() end) end
        elseif not selected and (self.circle=='acquaintance' or self.circle=='campfire') then
            f:Button(self.armed=='clear' and 'Confirm clearing category' or 'Remove everyone in this category',0,420+low,PW,function() if self.armed~='clear' then self.armed='clear'; A.RefreshBook(); return end; self.selected,self.armed=nil,nil; A.RemoveCircle(self.circle) end)
        end
        f:Finish()
    end
    return m
end

-- The same option keys as Layout A; changes are immediately visible everywhere.
function A.BuildBookWorldSettings(section, category, ui)
    local db, y = A.db, -4
    local function Check(key, label, note)
        y = ui.Choice(section, y, label, {{true, "On"}, {false, "Off"}}, function() return db[key] == true end, function(v) A.SetOption(key, v) end, note)
    end
    local function Action(label, action)
        local button = ui.Button(section, label, action)
        button:SetPoint("TOPLEFT", 4, y); y = y - 34
    end
    if category == "world" then
        local width = math.max(200, (section.layoutWidth or 340) - 8)
        local function WorldCheck(key, label)
            Check(key, label)
            y = y + 6 -- compact spacing between the simple world checkboxes
        end
        local function Heading(label)
            local text = section:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            text:SetPoint("TOPLEFT", 4, y); text:SetTextColor(unpack(SOFT)); text:SetText(label)
            if text.SetShadowOffset then text:SetShadowOffset(0, 0) end
            y = y - 18
        end
        local function PreviewButton(label, x, row, w, action, color)
            local button = ui.Button(section, label, action)
            button:SetPoint("TOPLEFT", x, row); button:SetSize(w, 26)
            local text = button.label or button:GetFontString()
            text:ClearAllPoints(); text:SetPoint("LEFT", 34, 0); text:SetPoint("RIGHT", -4, 0)
            text:SetJustifyH("LEFT"); text:SetWordWrap(false)
            A.StyleBookControl(button, false)
            if text.SetShadowOffset then text:SetShadowOffset(0, 0) end
            button.preview = button:CreateTexture(nil, "ARTWORK")
            button.preview:SetPoint("LEFT", 8, 0); button.preview:SetSize(18, 18)
            if color then
                local rim = button:CreateTexture(nil, "OVERLAY")
                rim:SetPoint("LEFT", 1, 0); rim:SetSize(32, 32)
                rim:SetTexture("Interface\\Buttons\\UI-Quickslot2")
                rim:SetVertexColor(.70, .55, .30, 1)
            end
            return button
        end
        WorldCheck("enabled", "Enable Companion Journal")
        Heading("Nameplates")
        WorldCheck("peopleIcons", "Show people's icons")
        local glyph = PreviewButton("Default icon for new people", 4, y, math.min(width, 240), function(button)
            A.PickGlyph(button, db.peopleNewGlyph or "diamond", db.colors.people, function(v) A.SetOption("peopleNewGlyph", v) end, true)
        end)
        section.updates[#section.updates + 1] = function()
            local value = db.peopleNewGlyph or "diamond"
            glyph.preview:SetTexture(value ~= "none" and A.GlyphPath(value) or "Interface\\Buttons\\UI-GroupLoot-Pass-Up")
            glyph.preview:SetVertexColor(unpack(value ~= "none" and db.colors.people or {1, 1, 1}))
        end
        Tip(glyph, "Choose the starting icon for a person you add. Their own card can use a different icon.")
        y = y - 30
        local names = A.Names()
        if names and names.PeopleIconPosition and names.SetPeopleIconPosition then
            y = ui.Choice(section, y, "Nameplate icon position", {{"left", "Before name"}, {"right", "After name"}, {"same", "With other icons"}},
                function() return names.PeopleIconPosition() end, function(v) names.SetPeopleIconPosition(v) end)
        elseif names then
            -- Older installed bridge versions need a reload to expose setters;
            -- never write the Journal's unrelated standalone setting here.
            Heading("Reload the UI to change nameplate icon position here.")
        else
            y = ui.Choice(section, y, "Icon position", {{"left", "Before name"}, {"right", "After name"}}, function() return db.peopleIconPosition or "left" end, function(v) A.SetOption("peopleIconPosition", v) end)
        end
        if names then WorldCheck("peopleRename", "Use their display name on nameplates") end
        WorldCheck("peopleTooltip", "Show notes and last seen on tooltips")
        Heading("Remembering people")
        WorldCheck("peopleLastSeen", "Remember when and where we met")
        WorldCheck("peopleRecognize", "Recognize my other characters' people")
        Heading("Recognition colours")
        local cell = (width - 8) / 3
        for i, entry in ipairs({{"recognizedCompanion", "Companion"}, {"recognizedAcquaintance", "Acquaintance"}, {"recognizedRival", "Rival"}}) do
            local key = entry[1]
            local swatch = PreviewButton(entry[2], 4 + (i - 1) * (cell + 4), y, cell, function(button)
                local hadOwn, original = db.colors[key] ~= nil, db.colors[key] or {1, 1, 1}
                original = {original[1], original[2], original[3]}
                A.PickColor(button, original[1], original[2], original[3],
                    function(r, g, b) db.colors[key] = {r, g, b}; A.Refresh() end,
                    function() db.colors[key] = hadOwn and original or nil; A.Refresh() end)
            end, true)
            section.updates[#section.updates + 1] = function() swatch.preview:SetColorTexture(unpack(db.colors[key] or {1, 1, 1})) end
            Tip(swatch, "Choose the colour for a " .. entry[2]:lower() .. " known by another character. Cancel restores the starting colour.")
        end
        y = y - 30
    elseif category == "recording" then
        Check("peopleJournal", "Record our adventures", "Keep quests, dungeons, levels and time together in the journal.")
        Check("journalSeen", "Record when we cross paths", "Adds occasional encounters outside your shared travels; requires recording to be enabled.")
        Check("moreMoments", "Record more moments", "In your own journal: books and plaques read, areas discovered, flight paths, spells from a trainer, reputation standings, duels, trade-skill ranks, honorable kills, rare creatures killed.")
    elseif category == "adding" then
        Check("peopleAutoGroup", "Remember groupmates as acquaintances")
        Check("peopleGroupIcon", "Give new groupmates the group icon")
        Check("peopleGroupPrompt", "Ask when groupmates leave", "Requires groupmate recording above. Offers a choice instead of adding them automatically.")
        -- (Preview sits at the end of the style choices' row, the same height as they are.
        -- The section frame is only a holder, so anchor from its left, never its right.)
        local rowY = y
        y = ui.Choice(section, y, "Group prompt", {{"cards", "Cards"}, {"legacy", "Legacy"}, {"minimal", "Minimal"}}, function() return db.groupPromptStyle == "loot" and "cards" or db.groupPromptStyle or "cards" end, function(v) db.groupPromptStyle = v; if A.RefreshGroupPrompt then A.RefreshGroupPrompt() end end)
        local previewButton = CreateFrame("Button", nil, section)
        previewButton.label = previewButton:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        previewButton.label:SetPoint("CENTER"); previewButton:SetFontString(previewButton.label)
        A.StyleBookControl(previewButton, false)
        previewButton:SetSize(96, 20)
        previewButton:SetPoint("TOPLEFT", math.max(220, (section.layoutWidth or 340) - 8 - 96), rowY - 20)
        previewButton:SetScript("OnClick", function() if A.ToggleGroupPromptPreview then A.ToggleGroupPromptPreview() end; A.RefreshBook() end)
        section.updates[#section.updates + 1] = function()
            previewButton:SetText(A.IsGroupPromptPreview and A.IsGroupPromptPreview() and "Hide preview" or "Preview")
        end
        Check("peopleAutoCampfire", "Remember people at my campfire", "Experimental: friendly players nearby with the same readable campfire timer; unavailable in combat or instances.")
        Check("peopleCampfireIcon", "Give them the campfire icon")
        Check("peopleMenu", "Add people from right-click menus")
        Action("Manage blocked people", function() A.OpenBookPeople(nil, "blocked") end)
    end
    return y
end
