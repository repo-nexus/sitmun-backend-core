package org.sitmun.plugin.core.domain;

import java.math.BigInteger;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ForeignKey;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.TableGenerator;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.UniqueConstraint;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import org.sitmun.plugin.core.constraints.CodeList;
import org.sitmun.plugin.core.constraints.CodeLists;
import org.sitmun.plugin.core.constraints.HttpURL;

/**
 * Territorial entity.
 */
@Entity
@Table(name = "STM_TERRITORY", uniqueConstraints = {
    @UniqueConstraint(name = "STM_TER_NOM_UK", columnNames = {"TER_NAME"})})
public class Territory {

  /**
   * Unique identifier.
   */
  @TableGenerator(
      name = "STM_ETERRIT_GEN",
      table = "STM_SEQUENCE",
      pkColumnName = "SEQ_NAME",
      valueColumnName = "SEQ_COUNT",
      pkColumnValue = "TER_ID",
      allocationSize = 1)
  @Id
  @GeneratedValue(strategy = GenerationType.TABLE, generator = "STM_ETERRIT_GEN")
  @Column(name = "TER_ID", precision = 11)
  private BigInteger id;

  /**
   * Geographic code.
   */
  @Column(name = "TER_CODMUN", length = 250)
  @NotBlank
  private String code;

  /**
   * Territory name.
   */
  @Column(name = "TER_NAME", length = 250)
  @NotBlank
  private String name;

  /**
   * Territorial authority name.
   */
  @Column(name = "TER_ADMNAME", length = 250)
  private String territorialAuthorityName;

  /**
   * Territorial authority address.
   */
  @Column(name = "TER_ADDRESS", length = 250)
  private String territorialAuthorityAddress;

  /**
   * Territorial authority email.
   */
  @Column(name = "TER_EMAIL", length = 250)
  @Email
  private String territorialAuthorityEmail;

  /**
   * Territory scope.
   */
  @Column(name = "TER_SCOPE", length = 250)
  @CodeList(CodeLists.TERRITORY_SCOPE)
  private String scope;

  /**
   * Link to the territorial authority logo.
   */
  @Column(name = "TER_LOGO", length = 250)
  @HttpURL
  private String territorialAuthorityLogo;

  /**
   * Bounding box of the territory.
   */
  @Column(name = "TER_EXTENT", length = 250)
  private String extent;

  /**
   * <code>true</code> if the territory is blocked.
   */
  @Column(name = "TER_BLOCKED")
  @NotNull
  private Boolean blocked;

  /**
   * Territory typology.
   */
  @ManyToOne
  @JoinColumn(name = "TER_TYPID", foreignKey = @ForeignKey(name = "STM_TER_FK_TGR"))
  private TerritoryType type;

  /**
   * Notes.
   */
  @Column(name = "TER_NOTE", length = 250)
  private String note;

  /**
   * Creation date.
   */
  @Column(name = "TER_CREATED")
  @Temporal(TemporalType.TIMESTAMP)
  private Date createdDate;

  /**
   * Territory typology.
   */
  @ManyToOne
  @JoinColumn(name = "TER_GTYPID", foreignKey = @ForeignKey(name = "STM_TER_FK_TET"))
  private TerritoryGroupType groupType;

  /**
   * Territories that are part of this territory.
   */
  @ManyToMany(cascade = {CascadeType.MERGE, CascadeType.PERSIST})
  @JoinTable(
      name = "STM_GRP_TER",
      joinColumns = @JoinColumn(
          name = "GTE_TERID",
          foreignKey = @ForeignKey(name = "STM_GRT_FK_TER")),
      inverseJoinColumns = @JoinColumn(
          name = "GTE_TERMID",
          foreignKey = @ForeignKey(name = "STM_GRT_FK_TEM")))
  private Set<Territory> members = new HashSet<>();

  /**
   * Territories of which this territory is part of.
   */
  @ManyToMany(cascade = {CascadeType.MERGE, CascadeType.PERSIST})
  @JoinTable(
      name = "STM_GRP_TER",
      joinColumns = @JoinColumn(
          name = "GTE_TERMID",
          foreignKey = @ForeignKey(name = "STM_GRT_FK_TERM")),
      inverseJoinColumns = @JoinColumn(
          name = "GTE_TERID",
          foreignKey = @ForeignKey(name = "STM_GRT_FK_TER")))
  private Set<Territory> memberOf = new HashSet<>();

  public Territory() {
  }

  private Territory(BigInteger id, @NotBlank String code,
                    @NotBlank String name, String territorialAuthorityName,
                    String territorialAuthorityAddress, String territorialAuthorityEmail,
                    String scope, String territorialAuthorityLogo, String extent,
                    @NotNull Boolean blocked, TerritoryType type, String note,
                    Date createdDate, TerritoryGroupType groupType,
                    Set<Territory> members,
                    Set<Territory> memberOf) {
    this.id = id;
    this.code = code;
    this.name = name;
    this.territorialAuthorityName = territorialAuthorityName;
    this.territorialAuthorityAddress = territorialAuthorityAddress;
    this.territorialAuthorityEmail = territorialAuthorityEmail;
    this.scope = scope;
    this.territorialAuthorityLogo = territorialAuthorityLogo;
    this.extent = extent;
    this.blocked = blocked;
    this.type = type;
    this.note = note;
    this.createdDate = createdDate;
    this.groupType = groupType;
    this.members = members;
    this.memberOf = memberOf;
  }

  public static Builder builder() {
    return new Builder();
  }

  public BigInteger getId() {
    return id;
  }

  public void setId(BigInteger id) {
    this.id = id;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getTerritorialAuthorityName() {
    return territorialAuthorityName;
  }

  public void setTerritorialAuthorityName(String territorialAuthorityName) {
    this.territorialAuthorityName = territorialAuthorityName;
  }

  public String getTerritorialAuthorityAddress() {
    return territorialAuthorityAddress;
  }

  public void setTerritorialAuthorityAddress(String territorialAuthorityAddress) {
    this.territorialAuthorityAddress = territorialAuthorityAddress;
  }

  public String getTerritorialAuthorityEmail() {
    return territorialAuthorityEmail;
  }

  public void setTerritorialAuthorityEmail(String territorialAuthorityEmail) {
    this.territorialAuthorityEmail = territorialAuthorityEmail;
  }

  public String getScope() {
    return scope;
  }

  public void setScope(String scope) {
    this.scope = scope;
  }

  public String getTerritorialAuthorityLogo() {
    return territorialAuthorityLogo;
  }

  public void setTerritorialAuthorityLogo(String territorialAuthorityLogo) {
    this.territorialAuthorityLogo = territorialAuthorityLogo;
  }

  public String getExtent() {
    return extent;
  }

  public void setExtent(String extent) {
    this.extent = extent;
  }

  public Boolean getBlocked() {
    return blocked;
  }

  public void setBlocked(Boolean blocked) {
    this.blocked = blocked;
  }

  public TerritoryType getType() {
    return type;
  }

  public void setType(TerritoryType type) {
    this.type = type;
  }

  public String getNote() {
    return note;
  }

  public void setNote(String note) {
    this.note = note;
  }

  public Date getCreatedDate() {
    return createdDate;
  }

  public void setCreatedDate(Date createdDate) {
    this.createdDate = createdDate;
  }

  public TerritoryGroupType getGroupType() {
    return groupType;
  }

  public void setGroupType(TerritoryGroupType groupType) {
    this.groupType = groupType;
  }

  public Set<Territory> getMembers() {
    return members;
  }

  public void setMembers(Set<Territory> members) {
    this.members = members;
  }

  public Set<Territory> getMemberOf() {
    return memberOf;
  }

  public void setMemberOf(Set<Territory> memberOf) {
    this.memberOf = memberOf;
  }

  @Override
  public boolean equals(Object o) {
    if (o instanceof Territory) {
      return ((Territory) o).getId().equals(this.getId());
    }
    return false;
  }

  @Override
  public int hashCode() {
    return super.hashCode();
  }

  public static class Builder {
    private BigInteger id;
    private @NotBlank String code;
    private @NotBlank String name;
    private String territorialAuthorityName;
    private String territorialAuthorityAddress;
    private String territorialAuthorityEmail;
    private String scope;
    private String territorialAuthorityLogo;
    private String extent;
    private @NotNull Boolean blocked;
    private TerritoryType type;
    private String note;
    private Date createdDate;
    private TerritoryGroupType groupType;
    private Set<Territory> members;
    private Set<Territory> memberOf;

    public Builder setId(BigInteger id) {
      this.id = id;
      return this;
    }

    public Builder setCode(String code) {
      this.code = code;
      return this;
    }

    public Builder setName(@NotBlank String name) {
      this.name = name;
      return this;
    }

    public Builder setTerritorialAuthorityName(String territorialAuthorityName) {
      this.territorialAuthorityName = territorialAuthorityName;
      return this;
    }

    public Builder setTerritorialAuthorityAddress(String territorialAuthorityAddress) {
      this.territorialAuthorityAddress = territorialAuthorityAddress;
      return this;
    }

    public Builder setTerritorialAuthorityEmail(String territorialAuthorityEmail) {
      this.territorialAuthorityEmail = territorialAuthorityEmail;
      return this;
    }

    public Builder setScope(String scope) {
      this.scope = scope;
      return this;
    }

    public Builder setTerritorialAuthorityLogo(String territorialAuthorityLogo) {
      this.territorialAuthorityLogo = territorialAuthorityLogo;
      return this;
    }

    public Builder setExtent(String extent) {
      this.extent = extent;
      return this;
    }

    public Builder setBlocked(@NotNull Boolean blocked) {
      this.blocked = blocked;
      return this;
    }

    public Builder setType(TerritoryType type) {
      this.type = type;
      return this;
    }

    public Builder setNote(String note) {
      this.note = note;
      return this;
    }

    public Builder setCreatedDate(Date createdDate) {
      this.createdDate = createdDate;
      return this;
    }

    public Builder setGroupType(TerritoryGroupType groupType) {
      this.groupType = groupType;
      return this;
    }

    public Builder setMembers(Set<Territory> members) {
      this.members = members;
      return this;
    }

    public Builder setMemberOf(Set<Territory> memberOf) {
      this.memberOf = memberOf;
      return this;
    }

    public Territory build() {
      return new Territory(id, code, name, territorialAuthorityName, territorialAuthorityAddress,
          territorialAuthorityEmail, scope, territorialAuthorityLogo, extent, blocked, type, note,
          createdDate, groupType, members, memberOf);
    }
  }
}
