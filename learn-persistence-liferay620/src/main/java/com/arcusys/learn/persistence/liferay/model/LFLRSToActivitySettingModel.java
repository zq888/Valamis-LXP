package com.arcusys.learn.persistence.liferay.model;

import com.liferay.portal.kernel.bean.AutoEscape;
import com.liferay.portal.model.BaseModel;
import com.liferay.portal.model.CacheModel;
import com.liferay.portal.service.ServiceContext;

import com.liferay.portlet.expando.model.ExpandoBridge;

import java.io.Serializable;

/**
 * The base model interface for the LFLRSToActivitySetting service. Represents a row in the &quot;Learn_LFLRSToActivitySetting&quot; database table, with each column mapped to a property of this class.
 *
 * <p>
 * This interface and its corresponding implementation {@link com.arcusys.learn.persistence.liferay.model.impl.LFLRSToActivitySettingModelImpl} exist only as a container for the default property accessors generated by ServiceBuilder. Helper methods and all application logic should be put in {@link com.arcusys.learn.persistence.liferay.model.impl.LFLRSToActivitySettingImpl}.
 * </p>
 *
 * @author Brian Wing Shun Chan
 * @see LFLRSToActivitySetting
 * @see com.arcusys.learn.persistence.liferay.model.impl.LFLRSToActivitySettingImpl
 * @see com.arcusys.learn.persistence.liferay.model.impl.LFLRSToActivitySettingModelImpl
 * @generated
 */
public interface LFLRSToActivitySettingModel extends BaseModel<LFLRSToActivitySetting> {
    /*
     * NOTE FOR DEVELOPERS:
     *
     * Never modify or reference this interface directly. All methods that expect a l f l r s to activity setting model instance should use the {@link LFLRSToActivitySetting} interface instead.
     */

    /**
     * Returns the primary key of this l f l r s to activity setting.
     *
     * @return the primary key of this l f l r s to activity setting
     */
    public long getPrimaryKey();

    /**
     * Sets the primary key of this l f l r s to activity setting.
     *
     * @param primaryKey the primary key of this l f l r s to activity setting
     */
    public void setPrimaryKey(long primaryKey);

    /**
     * Returns the ID of this l f l r s to activity setting.
     *
     * @return the ID of this l f l r s to activity setting
     */
    public long getId();

    /**
     * Sets the ID of this l f l r s to activity setting.
     *
     * @param id the ID of this l f l r s to activity setting
     */
    public void setId(long id);

    /**
     * Returns the course i d of this l f l r s to activity setting.
     *
     * @return the course i d of this l f l r s to activity setting
     */
    public Integer getCourseID();

    /**
     * Sets the course i d of this l f l r s to activity setting.
     *
     * @param courseID the course i d of this l f l r s to activity setting
     */
    public void setCourseID(Integer courseID);

    /**
     * Returns the title of this l f l r s to activity setting.
     *
     * @return the title of this l f l r s to activity setting
     */
    @AutoEscape
    public String getTitle();

    /**
     * Sets the title of this l f l r s to activity setting.
     *
     * @param title the title of this l f l r s to activity setting
     */
    public void setTitle(String title);

    /**
     * Returns the activity filter of this l f l r s to activity setting.
     *
     * @return the activity filter of this l f l r s to activity setting
     */
    @AutoEscape
    public String getActivityFilter();

    /**
     * Sets the activity filter of this l f l r s to activity setting.
     *
     * @param activityFilter the activity filter of this l f l r s to activity setting
     */
    public void setActivityFilter(String activityFilter);

    /**
     * Returns the verb filter of this l f l r s to activity setting.
     *
     * @return the verb filter of this l f l r s to activity setting
     */
    @AutoEscape
    public String getVerbFilter();

    /**
     * Sets the verb filter of this l f l r s to activity setting.
     *
     * @param verbFilter the verb filter of this l f l r s to activity setting
     */
    public void setVerbFilter(String verbFilter);

    @Override
    public boolean isNew();

    @Override
    public void setNew(boolean n);

    @Override
    public boolean isCachedModel();

    @Override
    public void setCachedModel(boolean cachedModel);

    @Override
    public boolean isEscapedModel();

    @Override
    public Serializable getPrimaryKeyObj();

    @Override
    public void setPrimaryKeyObj(Serializable primaryKeyObj);

    @Override
    public ExpandoBridge getExpandoBridge();

    @Override
    public void setExpandoBridgeAttributes(BaseModel<?> baseModel);

    @Override
    public void setExpandoBridgeAttributes(ExpandoBridge expandoBridge);

    @Override
    public void setExpandoBridgeAttributes(ServiceContext serviceContext);

    @Override
    public Object clone();

    @Override
    public int compareTo(LFLRSToActivitySetting lflrsToActivitySetting);

    @Override
    public int hashCode();

    @Override
    public CacheModel<LFLRSToActivitySetting> toCacheModel();

    @Override
    public LFLRSToActivitySetting toEscapedModel();

    @Override
    public LFLRSToActivitySetting toUnescapedModel();

    @Override
    public String toString();

    @Override
    public String toXmlString();
}