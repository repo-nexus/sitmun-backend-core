package org.sitmun.plugin.core.domain;

import java.math.BigInteger;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ForeignKey;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
import javax.persistence.TableGenerator;
import javax.validation.constraints.NotBlank;
import org.sitmun.plugin.core.constraints.CodeList;
import org.sitmun.plugin.core.constraints.CodeLists;
//import org.springframework.data.rest.webmvc.support.RepositoryEntityLinks;
//import org.springframework.hateoas.Identifiable;
//import org.springframework.hateoas.Link;
//import org.springframework.hateoas.Resource;
//import org.springframework.hateoas.ResourceSupport;

/**
 * Geographic Information Group.
 */
@Entity
@Table(name = "STM_GRP_GI")
public class CartographyGroup { //implements Identifiable {

  /**
   * Unique identifier.
   */
  @TableGenerator(
      name = "STM_GRPCARTO_GEN",
      table = "STM_SEQUENCE",
      pkColumnName = "SEQ_NAME",
      valueColumnName = "SEQ_COUNT",
      pkColumnValue = "GGI_ID",
      allocationSize = 1)
  @Id
  @GeneratedValue(strategy = GenerationType.TABLE, generator = "STM_GRPCARTO_GEN")
  @Column(name = "GGI_ID", precision = 11)
  private BigInteger id;

  /**
   * Group name.
   */
  @Column(name = "GGI_NAME", length = 80)
  @NotBlank
  private String name;

  /**
   * Group type.
   */
  @Column(name = "GGI_TYPE", length = 30)
  @CodeList(CodeLists.CARTOGRAPHY_GROUP_TYPE)
  private String type;

  /**
   * The set that contains all members in the group.
   */
  @ManyToMany
  @JoinTable(
      name = "STM_GGI_GI",
      joinColumns = @JoinColumn(
          name = "GGG_GGIID",
          foreignKey = @ForeignKey(name = "STM_GCC_FK_GCA")),
      inverseJoinColumns = @JoinColumn(
          name = "GGG_GIID",
          foreignKey = @ForeignKey(name = "STM_GCC_FK_CAR")))
  private Set<Cartography> members;

  /**
   * The set that contains the roles for which this group is available.
   */
  @ManyToMany
  @JoinTable(
      name = "STM_ROL_GGI",
      joinColumns = @JoinColumn(
          name = "RGG_GGIID",
          foreignKey = @ForeignKey(name = "STM_RGC_FK_GCA")),
      inverseJoinColumns = @JoinColumn(
          name = "RGG_ROLEID",
          foreignKey = @ForeignKey(name = "STM_RGC_FK_ROL")))
  private Set<Role> roles;

  public BigInteger getId() {
    return id;
  }

  public void setId(BigInteger id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public Set<Cartography> getMembers() {
    return members;
  }

  public void setMembers(Set<Cartography> members) {
    this.members = members;
  }

  public Set<Role> getRoles() {
    return roles;
  }

  public void setRoles(Set<Role> roles) {
    this.roles = roles;
  }

  //  public ResourceSupport toResource(RepositoryEntityLinks links) {
  //    Link selfLink = links.linkForSingleResource(this).withSelfRel();
  //    ResourceSupport res = new Resource<>(this, selfLink);
  //    res.add(links.linkForSingleResource(this).slash("members").withRel("members"));
  //    res.add(links.linkForSingleResource(this).slash("roles").withRel("roles"));
  //    return res;
  //  }

}
