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

-- Exsto Number Choice

PANEL = {}

function PANEL:Init()

	self:MaxFontSize( 20 )
	self:SetAlignX( TEXT_ALIGN_LEFT )
	self:SetMaxTextWide( 130 )
	
	-- Create our slider.
	self.Slider = self:Add( "DSlider", self )
		self.Slider:SetLockY( 0.5 )
		self.Slider:SetTrapInside( true )
		self.Slider:Dock( FILL )
		self.Slider:SetHeight( 16 )
		self.Slider.TranslateValues = function( slide, x, y ) return self:TranslateValues( x, y ) end
		self.Slider:SetVisible( false ) 
		Derma_Hook( self.Slider, "Paint", "Paint", "NumSlider" )
		
	self.Entry = self:Add( "DTextEntry", self )
		self.Entry:SetNumeric( true )
		self.Entry:Dock( RIGHT )
		self.Entry:DockMargin( 4, 4, 4, 4 )
	
end

function PANEL:TranslateValues( x, y )
	self:SetValue( self:GetMin() + ( x * self:GetRange() ), true );
	return self:GetFraction(), y 
end

function PANEL:GetMin() return self._Min end
function PANEL:GetMax() return self._Max end
function PANEL:GetValue() return self._Val end
function PANEL:GetRange() return self:GetMax() - self:GetMin() end
function PANEL:GetFraction() return ( self:GetValue() - self:GetMin() ) / self:GetRange() end

function PANEL:SetMin( val ) self._Min = val end
function PANEL:SetMax( val ) self._Max = val  end
function PANEL:SetValue( val, trans ) 
	val = math.Clamp( math.ceil( val ), self:GetMin(), self:GetMax() )
	
	self._Val = val
	self.Entry:SetValue( val )
	
	if !trans then self.Slider:SetSlideX( self:GetFraction() ) end
	
	self:OnValueSet( self:GetValue() )
end
function PANEL:SetFraction( f )
	self._Fraction = self:GetMin() + ( f * self:GetRange() )
end
function PANEL:SetDecimals( val ) self._Decimals = val end

-- Override ExButton's.  We now need to convert the button into the wanger.  Whoaurgoarghoa!
function PANEL:DoClick()
	self.Slider:SetVisible( not self.Slider:IsVisible() )
	self:HideText( self.Slider:IsVisible() )
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

derma.DefineControl( "ExNumberChoice", "Exsto Number Choice", PANEL, "ExButton" )