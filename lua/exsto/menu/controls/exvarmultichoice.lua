--[[
	Exsto
	Copyright (C) 2013  Prefanatic

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

-- Exsto Text Choice

PANEL = {}

function PANEL:Init()

	self:MaxFontSize( 20 )
	self:SetAlignX( TEXT_ALIGN_LEFT )
	self:SetMaxTextWide( 130 )
	
	self.Entry = self:Add( "DComboBox", self )
		self.Entry:Dock( FILL )
		self.Entry:DockMargin( 4, 4, 4, 4 )
		self.Entry:SetVisible( false )
		self.Entry.OnSelect = function( entry, index, val, data ) self:OnSelect( index, val, data ) end
end

function PANEL:OnSelect( index, name, data )
	self:SetValue( name )
end

function PANEL:AddChoice( name, data )
	self.Entry:AddChoice( name, data )
end

function PANEL:SetValue( val ) self.Entry:SetValue( val ) self:OnValueSet( self:GetValue() ) end
function PANEL:GetValue() return self.Entry:GetValue() end

-- Override ExButton's.  We now need to convert the button into the wanger.  Whoaurgoarghoa!
function PANEL:DoClick()
	self.Entry:SetVisible( not self.Entry:IsVisible() )
	self:HideText( self.Entry:IsVisible() )
end

function PANEL:Paint()
	local w, h = self:GetSize()
	
	if self.Hovered then
		self:GetSkin().tex.Input.ComboBox.Hover( 0, 0, w, h )
	else
		self:GetSkin().tex.Input.ComboBox.Normal( 0, 0, w, h )
	end
	
	if !self._HideText then
		
		-- Text
		local x = self:GetWide() / 2
		local y = self:GetTall() / 2
		
		if self._AlignX == TEXT_ALIGN_LEFT then x = self:GetTextPadding() end
		
		--if self._AlignY == TEXT_ALIGN_TOP then y = y + self._YMod end
		
		draw.SimpleText( self:GetText(), self:GetFont() .. self:GetFontSize(), x, y, self:GetTextColor(), self._AlignX, self._AlignY )
		
	end
end

derma.DefineControl( "ExVarMultiChoice", "Exsto Multi Choice", PANEL, "ExButton" )