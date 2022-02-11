include $(TOPDIR)/rules.mk

PKG_NAME:=falter-berlin-service-registrar
PKG_VERSION:=0.1

include $(INCLUDE_DIR)/package.mk

define Package/falter-berlin-service-registrar/default
  SECTION:=falter-berlin
  CATEGORY:=falter-berlin
  URL:=http://github.com/Freifunk-Spalter/packages
  PKGARCH:=all
endef
#EXTRA_DEPENDS:=ip-full, kmod-macvlan, wg-installer-client

define Package/falter-berlin-service-registrar
	$(call Package/falter-berlin-service-registrar/default)
	TITLE:=Freifunk Berlin Service Registrar
endef


define Package/falter-berlin-service-registrar/description
  App for simplifying the anouncment of services in Freifunk Berlin Network
endef


define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/falter-berlin-service-registrar/conffiles
/etc/config/service-registrar
endef

define Package/falter-berlin-service-registrar/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) ./files/autoupdate.sh $(1)/usr/bin/autoupdate
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/autoupdate.conf $(1)/etc/config/autoupdate
	$(INSTALL_DIR) $(1)/lib/autoupdate
	$(CP) ./files/lib_autoupdate.sh $(1)/lib/autoupdate/lib_autoupdate.sh
endef


$(eval $(call BuildPackage,falter-berlin-service-registrar))
